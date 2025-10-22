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
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF9D4EDD),
          child: Icon(Icons.money, color: Colors.white),
        ),
        title: Text(
          expense.description,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          "${expense.date.day}/${expense.date.month}/${expense.date.year}",
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Text(
          "₹${expense.amount.toStringAsFixed(2)}",
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.yellowAccent),
        ),
      ),
    );
  }
}
