import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';
import 'add_expense_screen.dart';
import '../widgets/expense_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Expense> box;

  @override
  void initState() {
    super.initState();
    box = Hive.box<Expense>('expenses');
  }

  void _addExpense(Expense e) async {
    await box.add(e);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final expenses = box.values.toList().reversed.toList();
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Expense Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (_, i) => ExpenseCard(expense: expenses[i]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddExpenseScreen(onAdd: _addExpense),
            ),
          );
        },
        backgroundColor: const Color(0xFF00FF88),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
