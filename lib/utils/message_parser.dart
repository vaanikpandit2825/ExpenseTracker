
enum TxnType { expense, income, unknown }

class MessageParser {
  // Bank senders list
  static const bankSenders = [
    'HDFC', 'ICICI', 'SBICRM', 'AX-BANK', 'UPI', 'IMPS'
  ];

  // Check if a message is from a bank
  static bool isBankMessage(String sender, String body) {
    sender = sender.toUpperCase();
    body = body.toUpperCase();

    // Check sender name
    for (final bank in bankSenders) {
      if (sender.contains(bank) || body.contains(bank)) return true;
    }

    // Check for key keywords
    final keywords = ['DEBITED', 'CREDITED', 'PURCHASE', 'TXN', 'WITHDRAWN'];
    for (final kw in keywords) {
      if (body.contains(kw)) return true;
    }

    return false;
  }

  // Extract amount from message
  static double? extractAmount(String text) {
    final patterns = [
      RegExp(r'(?:Rs\.?|INR|₹)\s?([0-9,]+(?:\.[0-9]{1,2})?)', caseSensitive: false),
      RegExp(r'([0-9,]+(?:\.[0-9]{1,2})?)\s?(?:INR|Rs\.?|₹)', caseSensitive: false),
      RegExp(r'amount(?:\:|\s)?([0-9,]+(?:\.[0-9]{1,2})?)', caseSensitive: false),
      RegExp(r'Transaction of\s+([0-9,]+(?:\.[0-9]{1,2})?)', caseSensitive: false),
    ];

    for (final p in patterns) {
      final m = p.firstMatch(text);
      if (m != null && m.groupCount >= 1) {
        final raw = m.group(1)!.replaceAll(',', '');
        return double.tryParse(raw);
      }
    }

    return null;
  }

  // Detect if expense or income
  static TxnType detectType(String text) {
    text = text.toLowerCase();

    if (RegExp(r'\b(debit|debited|purchase|spent|withdrawn|paid)\b').hasMatch(text)) {
      return TxnType.expense;
    }
    if (RegExp(r'\b(credit|credited|deposit|received|refund)\b').hasMatch(text)) {
      return TxnType.income;
    }

    return TxnType.unknown;
  }

  // Map message to a category
  static String mapCategory(String text) {
    final categoryRules = {
      RegExp(r'\b(zomato|swiggy|ubereats|dominos)\b'): 'Food',
      RegExp(r'\b(amazon|flipkart|myntra|ajio)\b'): 'Shopping',
      RegExp(r'\b(petrol|fuel|hpcl|indianoil)\b'): 'Transport',
      RegExp(r'\b(upi|atm|withdrawal)\b'): 'Cash',
    };

    final t = text.toLowerCase();
    for (final entry in categoryRules.entries) {
      if (entry.key.hasMatch(t)) return entry.value;
    }

    return 'Other';
  }
}
