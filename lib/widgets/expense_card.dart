import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  const ExpenseCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.money, color: Color(0xFF00FF88)),
        title: Text(
          "₹${expense.amount.toStringAsFixed(0)}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          "${expense.description} • ${expense.date.day}/${expense.date.month}/${expense.date.year}",
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
