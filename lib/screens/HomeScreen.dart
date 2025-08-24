import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, List<Map<String, dynamic>>> _expenses = {
    "Food": [],
    "Outing": [],
    "Stationery": [],
  };

  // separate controllers per category
  final Map<String, Map<String, TextEditingController>> _controllers = {
    "Food": {
      "title": TextEditingController(),
      "amount": TextEditingController(),
    },
    "Outing": {
      "title": TextEditingController(),
      "amount": TextEditingController(),
    },
    "Stationery": {
      "title": TextEditingController(),
      "amount": TextEditingController(),
    },
  };

  void _addExpense(String category) {
    final title = _controllers[category]!["title"]!.text.trim();
    final amount =
        double.tryParse(_controllers[category]!["amount"]!.text.trim()) ?? 0;

    if (title.isNotEmpty && amount > 0) {
      setState(() {
        _expenses[category]!.add({"title": title, "amount": amount});
      });
      _controllers[category]!["title"]!.clear();
      _controllers[category]!["amount"]!.clear();
    }
  }

  Widget _buildInputBox(String hint, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBDC3C7)),
      ),
      child: EditableText(
        controller: controller,
        focusNode: FocusNode(),
        style: const TextStyle(color: Color(0xFF2C3E50), fontSize: 16),
        cursorColor: const Color(0xFF2980B9),
        backgroundCursorColor: const Color(0xFFBDC3C7),
        keyboardType: type,
      ),
    );
  }

  Widget _buildAddButton(String category) {
    return GestureDetector(
      onTap: () => _addExpense(category),
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6A89CC), Color(0xFF1E3799)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E3799).withOpacity(0.3),
              offset: const Offset(2, 3),
              blurRadius: 6,
            )
          ],
        ),
        child: const Text(
          "➕ Add Expense",
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(String category) {
    final expenses = _expenses[category]!;
    final titleCtrl = _controllers[category]!["title"]!;
    final amountCtrl = _controllers[category]!["amount"]!;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFBDC3C7).withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(3, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 8),
          ...expenses.map((exp) => Text(
                "• ${exp["title"]}: ₹${exp["amount"]}",
                style: const TextStyle(fontSize: 15, color: Color(0xFF34495E)),
              )),
          const SizedBox(height: 10),
          _buildInputBox("Title", titleCtrl),
          _buildInputBox("Amount", amountCtrl, type: TextInputType.number),
          _buildAddButton(category),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F7FA),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildCategory("Food"),
              _buildCategory("Outing"),
              _buildCategory("Stationery"),
            ],
          ),
        ),
      ),
    );
  }
}
