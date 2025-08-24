import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final void Function(int index) onDelete;

  const ExpenseList({
    super.key,
    required this.expenses,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Center(child: Text("No expenses yet. Add one above!"));
    }

    return ListView.separated(
      itemCount: expenses.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final e = expenses[index];
        return Dismissible(
          key: ValueKey("${e.category}-${e.amount}-${e.date.millisecondsSinceEpoch}"),
          background: Container(
            color: Colors.red.withOpacity(0.1),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Icon(Icons.delete, color: Colors.red),
          ),
          secondaryBackground: Container(
            color: Colors.red.withOpacity(0.1),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Icon(Icons.delete, color: Colors.red),
          ),
          onDismissed: (_) => onDelete(index),
          child: ListTile(
            leading: const Icon(Icons.attach_money),
            title: Text(e.category),
            subtitle: Text(
              "${e.date.day.toString().padLeft(2, '0')}/"
              "${e.date.month.toString().padLeft(2, '0')}/"
              "${e.date.year}",
            ),
            trailing: Text("₹${e.amount.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        );
      },
    );
  }
}
