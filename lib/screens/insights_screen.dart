import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense_model.dart';
import 'package:intl/intl.dart';

class InsightsScreen extends StatelessWidget {
  final List<Expense> expenses;

  const InsightsScreen({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    // Group expenses by category
    Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    // Prepare pie chart data
    List<PieChartSectionData> pieSections = [];
    final colors = [
      Colors.purpleAccent,
      Colors.blueAccent,
      Colors.orangeAccent,
      Colors.greenAccent,
      Colors.pinkAccent,
    ];
    int i = 0;
    categoryTotals.forEach((category, total) {
      pieSections.add(
        PieChartSectionData(
          color: colors[i % colors.length],
          value: total,
          title: category,
          radius: 70,
          titleStyle: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      );
      i++;
    });

    // Group by day for bar chart
    Map<String, double> dailyTotals = {};
    for (var expense in expenses) {
      String day = DateFormat('dd MMM').format(expense.date);
      dailyTotals[day] = (dailyTotals[day] ?? 0) + expense.amount;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Insights"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Spending by Category",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              child: PieChart(
                PieChartData(
                  sections: pieSections,
                  centerSpaceRadius: 40,
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Daily Spending",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < dailyTotals.length) {
                            return Text(
                              dailyTotals.keys.elementAt(value.toInt()),
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(dailyTotals.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: dailyTotals.values.elementAt(index),
                          color: Colors.purpleAccent,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
