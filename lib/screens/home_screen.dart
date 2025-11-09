import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../screens/add_expense_screen.dart';
import '../screens/analytics_screen.dart';
import '../widgets/expense_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> expenses = [];
  double budget = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (budget <= 0) _showEditBudgetDialog();
    });
  }

  // ----- Set Budget -----
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

  // ----- Add Expense -----
  void _addExpense(Expense expense) {
    setState(() => expenses.add(expense));
  }

  // ----- Total Spent -----
  double get totalSpent => expenses.fold(0.0, (sum, e) => sum + e.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181733),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1E1E2F),
        centerTitle: true,
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AnalyticsScreen(expenses: expenses),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7E60FA),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddExpenseScreen(
                onAdd: _addExpense,
                existingExpenses: expenses,
                currentBudget: budget,
              ),
            ),
          );
          setState(() {}); // Refresh when returning
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Card
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                child: Card(
                  elevation: 13,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
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
                            padding: const EdgeInsets.all(7),
                            child: const Icon(Icons.credit_card,
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
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28)),
                                Text(
                                  budget > 0
                                      ? "${((totalSpent / budget) * 100).toStringAsFixed(1)}% of budget • Remaining ₹${(budget - totalSpent).toStringAsFixed(2)}"
                                      : "Set a budget to track spending.",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.90),
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: _showEditBudgetDialog,
                            child: const Icon(Icons.settings,
                                color: Colors.white, size: 26),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const Text("Expenses",
                  style: TextStyle(
                      fontSize: 23,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),

              if (expenses.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 28),
                    child: Text(
                        "No expenses yet.\nTap + to add your first one!",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white54, fontSize: 15)),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: expenses.length,
                  itemBuilder: (ctx, i) {
                    final expense = expenses[i];
                    return Dismissible(
                      key: Key(expense.date.toString()),
                      background: Container(color: Colors.red),
                      onDismissed: (_) => setState(() => expenses.removeAt(i)),
                      child: ExpenseCard(expense: expense),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
