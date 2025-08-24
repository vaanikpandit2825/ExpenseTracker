import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseChart({super.key, required this.expenses});

  Map<String, double> _categoryTotals() {
    final map = <String, double>{};
    for (final e in expenses) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Center(child: Text("No data yet"));
    }

    final totals = _categoryTotals();
    final totalSum = totals.values.fold<double>(0, (s, v) => s + v);

    final sections = totals.entries.map((entry) {
      final percent = totalSum == 0 ? 0 : (entry.value / totalSum) * 100;
      return PieChartSectionData(
        value: entry.value,
        title: "${entry.key}\n${percent.toStringAsFixed(0)}%",
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      );
    }).toList();

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: sections,
      ),
    );
  }
}
