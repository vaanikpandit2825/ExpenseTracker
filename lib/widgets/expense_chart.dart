import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseCharts extends StatelessWidget {
  final List<Expense> expenses;
  const ExpenseCharts({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final categoryTotals = <String, double>{};
    for (var e in expenses) {
      categoryTotals[e.category] = (categoryTotals[e.category] ?? 0) + e.amount;
    }
    final total = expenses.fold(0.0, (sum, e) => sum + e.amount);

    // Pie chart data
    final pieSections = <PieChartSectionData>[];
    List<Color> colors = [
      Colors.deepPurple,
      Colors.pinkAccent,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
    ];
    int idx = 0;
    categoryTotals.forEach((cat, value) {
      pieSections.add(PieChartSectionData(
        color: colors[idx % colors.length],
        value: value,
        title: total == 0 ? '' : "${((value/total)*100).toStringAsFixed(1)}%",
        radius: 50,
        titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
      ));
      idx++;
    });

    // Bar chart data
    final barGroups = <BarChartGroupData>[];
    idx = 0;
    categoryTotals.forEach((cat, value) {
      barGroups.add(BarChartGroupData(
        x: idx,
        barRods: [
          BarChartRodData(
            toY: value,
            color: colors[idx % colors.length],
            width: 16,
            borderRadius: BorderRadius.circular(6),
          )
        ],
      ));
      idx++;
    });

    return Column(
      children: [
        const Text("Spending Breakdown", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          height: 180,
          child: PieChart(
            PieChartData(
              sections: pieSections,
              centerSpaceRadius: 35,
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
            ),
            swapAnimationDuration: const Duration(milliseconds: 800),
            swapAnimationCurve: Curves.easeOut,
          ),
        ),
        const SizedBox(height: 30),
        Container(
          height: 180,
          child: BarChart(
            BarChartData(
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int i = value.toInt();
                      if (i < categoryTotals.length) {
                        return Text(categoryTotals.keys.elementAt(i), style: const TextStyle(color: Colors.white, fontSize: 11));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              barGroups: barGroups,
              barTouchData: BarTouchData(enabled: true),
            ),
            swapAnimationDuration: const Duration(milliseconds: 800),
            swapAnimationCurve: Curves.easeOut,
          ),
        ),
      ],
    );
  }
}