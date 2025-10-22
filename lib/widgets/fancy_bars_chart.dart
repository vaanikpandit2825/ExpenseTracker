import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';

class FancyBarChart extends StatelessWidget {
  final List<Expense> expenses;
  const FancyBarChart({Key? key, required this.expenses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryTotals = <String, double>{};
    for (var e in expenses) {
      categoryTotals[e.category] = (categoryTotals[e.category] ?? 0) + e.amount;
    }
    final total = expenses.fold(0.0, (sum, e) => sum + e.amount);

    final colors = [
      [Color(0xFF9D4EDD), Color(0xFF5F2BBF)],
      [Color(0xFFF67280), Color(0xFFFCB2A9)],
      [Color(0xFF355C7D), Color(0xFF6C5B7B)],
      [Color(0xFF99B898), Color(0xFF97C79B)],
      [Color(0xFF00D2FF), Color(0xFF3A7BD5)],
    ];
    int idx = 0;
    final barGroups = categoryTotals.entries.map((entry) {
      return BarChartGroupData(
        x: idx,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            gradient: LinearGradient(
              colors: colors[idx % colors.length],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 28,
            borderRadius: BorderRadius.circular(16),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: total > 0 ? total : 1,
              color: colors[idx % colors.length][0].withOpacity(0.18),
            ),
          )
        ],
      );
      idx++;
    }).toList();

    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF232526), Color(0xFF4E4376)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.22),
            blurRadius: 24, spreadRadius: 2, offset: Offset(0, 6),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (categoryTotals.values.isNotEmpty)
              ? (categoryTotals.values.reduce((a, b) => a > b ? a : b) + 10)
              : 10,
          barGroups: barGroups,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.deepPurple.shade400,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final cat = categoryTotals.keys.elementAt(group.x);
                return BarTooltipItem(
                  "$cat\n₹${rod.toY.toStringAsFixed(2)}",
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                );
              }
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) =>
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      categoryTotals.keys.elementAt(value.toInt()),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),
                    ),
                  ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
        swapAnimationDuration: Duration(milliseconds: 900),
        swapAnimationCurve: Curves.easeOutCubic,
      ),
    );
  }
}
