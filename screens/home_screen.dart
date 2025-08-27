import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  double? monthlyBudget;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
    _loadBudget();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getDouble('MonthlyBudget');
    setState(() => monthlyBudget = saved);

    // Ask on first launch
    if (saved == null) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _showSetBudgetDialog());
    }
  }

  Future<void> _saveBudget(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('MonthlyBudget', value);
    setState(() => monthlyBudget = value);
  }

  void _showSetBudgetDialog() {
    final controller = TextEditingController(
      text: monthlyBudget == null ? '' : monthlyBudget!.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Set Monthly Budget'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Enter amount (₹)'),
        ),
        actions: [
          if (monthlyBudget != null)
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
          ElevatedButton(
            onPressed: () {
              final v = double.tryParse(controller.text);
              if (v != null && v > 0) {
                _saveBudget(v);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Helpers to compute monthly totals from Hive box values
  double _monthlyTotal(Iterable<Expense> items) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1); // First of the month
    return items
        .where((e) =>
            e.date.isAfter(monthStart.subtract(const Duration(seconds: 1))))
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double _monthlyPercent(double spent) {
    if (monthlyBudget == null || monthlyBudget == 0) return 0;
    return (spent / monthlyBudget!) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Expense>('expenses');

    return Scaffold(
      floatingActionButton: ScaleTransition(
        scale: _animation,
        child: FloatingActionButton(
          backgroundColor: Colors.purpleAccent,
          child: const Icon(Icons.add, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddExpenseScreen(
                  onAdd: (expense) {
                    box.add(expense); // persist to Hive
                    setState(() {}); // refresh UI if needed
                  },
                ),
              ),
            );
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box<Expense> b, _) {
                final items = b.values.toList().cast<Expense>();
                // newest first
                items.sort((a, z) => z.date.compareTo(a.date));

                final monthlySpent = _monthlyTotal(items);
                final monthlyPct = _monthlyPercent(monthlySpent);
                final remaining =
                    monthlyBudget == null ? 0 : (monthlyBudget! - monthlySpent);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeTransition(
                      opacity: _animation,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        color: Colors.deepPurpleAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              const Icon(Icons.show_chart,
                                  size: 40, color: Colors.yellowAccent),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "This Month",
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "₹${monthlySpent.toStringAsFixed(2)} spent",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      monthlyBudget == null
                                          ? "Set a monthly budget"
                                          : "${monthlyPct.toStringAsFixed(1)}% of budget • Remaining ₹${remaining.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.settings,
                                    color: Colors.white),
                                onPressed: _showSetBudgetDialog,
                                tooltip: 'Edit Budget',
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Expenses",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: items.isEmpty
                          ? const Center(
                              child: Text(
                                "No expenses yet!",
                                style: TextStyle(color: Colors.white70),
                              ),
                            )
                          : ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final e = items[index];
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.purpleAccent,
                                          blurRadius: 5,
                                          spreadRadius: 1)
                                    ],
                                  ),
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                      backgroundColor: Colors.purpleAccent,
                                      child: Icon(Icons.money,
                                          color: Colors.black, size: 20),
                                    ),
                                    title: Text(
                                      e.description,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    subtitle: Text(
                                      DateFormat('dd MMM yyyy').format(e.date),
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 14),
                                    ),
                                    trailing: Text(
                                      "₹${e.amount.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          color: Colors.yellowAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
