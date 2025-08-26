import 'package:flutter/material.dart';
import '../models/expense.dart';

class InsightsCard extends StatelessWidget {
  final List<Expense> expenses;
  const InsightsCard({super.key, required this.expenses});

  double getTotalThisWeek() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return expenses
        .where((e) => e.date.isAfter(startOfWeek))
        .fold(0, (sum, e) => sum + e.amount);
  }

  double getTotalLastWeek() {
    DateTime now = DateTime.now();
    DateTime startOfThisWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime startOfLastWeek = startOfThisWeek.subtract(const Duration(days: 7));
    DateTime endOfLastWeek = startOfThisWeek.subtract(const Duration(days: 1));
    return expenses
        .where((e) => e.date.isAfter(startOfLastWeek) && e.date.isBefore(endOfLastWeek))
        .fold(0, (sum, e) => sum + e.amount);
  }

  @override
  Widget build(BuildContext context) {
    double thisWeek = getTotalThisWeek();
    double lastWeek = getTotalLastWeek();
    double percentChange = lastWeek == 0 ? 0 : ((thisWeek - lastWeek) / lastWeek) * 100;

    String trend = percentChange > 0 ? "🔺 Spent more" : "⬇️ Spent less";

    return Card(
      color: Colors.white10,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "This Week",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "₹${thisWeek.toStringAsFixed(0)}",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "$trend ${percentChange.abs().toStringAsFixed(1)}%",
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
