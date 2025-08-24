import '../models/expense.dart';

class Insights {
  static String smartTip(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return "Add expenses to get instant insights!";
    }

    // Total
    final total = expenses.fold<double>(0, (s, e) => s + e.amount);

    // Category totals
    final Map<String, double> byCat = {};
    for (final e in expenses) {
      byCat[e.category] = (byCat[e.category] ?? 0) + e.amount;
    }

    // Top category
    final topEntry = byCat.entries.reduce((a, b) => a.value >= b.value ? a : b);
    final topCat = topEntry.key;
    final topPct = (topEntry.value / total * 100);

    // Simple heuristics (fake AI 😄)
    if (topPct >= 40) {
      return "💡 You’re spending heavily on $topCat (${topPct.toStringAsFixed(0)}%). Set a weekly cap to control it.";
    }
    if (total > 5000) {
      return "💡 High total spend this period (₹${total.toStringAsFixed(0)}). Consider a 10% monthly savings target.";
    }

    // Trend (last 7 days vs previous 7 days)
    final now = DateTime.now();
    final last7 = expenses.where((e) => e.date.isAfter(now.subtract(const Duration(days: 7)))).toList();
    final prev7 = expenses.where((e) =>
        e.date.isAfter(now.subtract(const Duration(days: 14))) &&
        e.date.isBefore(now.subtract(const Duration(days: 7)))).toList();

    final last7Total = last7.fold<double>(0, (s, e) => s + e.amount);
    final prev7Total = prev7.fold<double>(0, (s, e) => s + e.amount);

    if (prev7Total > 0 && last7Total > prev7Total * 1.2) {
      return "💡 Your last 7-day spending rose by ~${(((last7Total - prev7Total) / prev7Total) * 100).toStringAsFixed(0)}%. Try reducing impulse buys.";
    }

    return "💡 Nice balance so far. Keep tracking daily and review weekly for better control.";
  }
}
