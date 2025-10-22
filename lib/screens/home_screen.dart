import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/fancy_pie_chart.dart';
import '../widgets/fancy_bars_chart.dart';
import '../widgets/expense_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> expenses = [];
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _selectedCategory = "Food";
  double budget = 0;

  final List<String> categories = [
    "Food",
    "Travel",
    "Bills",
    "Shopping",
    "Other"
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (budget <= 0) _showEditBudgetDialog();
    });
  }

  Future<void> _showEditBudgetDialog() async {
    final controller =
        TextEditingController(text: budget > 0 ? budget.toString() : '');
    double? newBudget = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF252242),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Set Monthly Budget',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: "Monthly Budget (₹)",
            labelStyle: TextStyle(color: Colors.white70),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child:
                const Text("Cancel", style: TextStyle(color: Colors.redAccent)),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null && value > 0) {
                Navigator.of(ctx).pop(value);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
    if (newBudget != null && newBudget > 0) {
      setState(() => budget = newBudget);
    }
  }

  void _addExpense() {
    if (_amountController.text.isEmpty || _descController.text.isEmpty) return;
    final amountValue = double.tryParse(_amountController.text);
    if (amountValue == null || amountValue <= 0) return;
    final expense = Expense(
      amount: amountValue,
      description: _descController.text,
      category: _selectedCategory,
      date: DateTime.now(),
    );
    setState(() => expenses.add(expense));
    _amountController.clear();
    _descController.clear();
    Navigator.pop(context);
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF252242),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title:
              const Text("Add Expense", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Amount (₹)",
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                dropdownColor: const Color(0xFF292960),
                value: _selectedCategory,
                items: categories
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c,
                              style: const TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
                decoration: const InputDecoration(
                  labelText: "Category",
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel",
                  style: TextStyle(color: Colors.redAccent)),
            ),
            ElevatedButton(
              onPressed: _addExpense,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7E60FA),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  double get totalSpent => expenses.fold(0.0, (sum, e) => sum + e.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181733),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1E1E2F),
        title: null,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7E60FA),
        onPressed: _showAddExpenseDialog,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary card, modern gradient/elevated look:
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                child: Card(
                  elevation: 13,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7E60FA), Color(0xFF9D4EDD)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 20),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.yellow[700],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(7),
                            child: Icon(Icons.credit_card,
                                color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("This Month",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14)),
                                Text("₹${totalSpent.toStringAsFixed(2)} spent",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                        letterSpacing: 0.1)),
                                Text(
                                  budget > 0
                                      ? "${((totalSpent / budget) * 100).toStringAsFixed(1)}% of budget • Remaining ₹${(budget - totalSpent).toStringAsFixed(2)}"
                                      : "Set a budget to track your spending.",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.90),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      height: 1.3),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: _showEditBudgetDialog,
                            child: Icon(Icons.settings,
                                color: Colors.white, size: 26),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 13),
              const Text("Expenses",
                  style: TextStyle(
                      fontSize: 23,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6)),
              const SizedBox(height: 6),
              if (expenses.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 28),
                    child: Text(
                        "No expenses yet.\nTap + to add your first one!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white54,
                            fontSize: 15,
                            fontWeight: FontWeight.w400)),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: expenses.length,
                  itemBuilder: (ctx, i) => ExpenseCard(expense: expenses[i]),
                ),
              const SizedBox(height: 30),
              // --- Analytics Card Section ---
              Card(
                elevation: 12,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: Color(0xFF252242),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 23, horizontal: 10),
                  child: Column(
                    children: [
                      Text("Analytics",
                          style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3)),
                      SizedBox(height: 10),
                      FancyPieChart(expenses: expenses),
                      SizedBox(height: 18),
                      FancyBarChart(expenses: expenses),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18),
              // Optionally add a quote, summary, or link here at bottom of page
            ],
          ),
        ),
      ),
    );
  }
}
