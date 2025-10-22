import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';

class FancyPieChart extends StatefulWidget {
  final List<Expense> expenses;
  const FancyPieChart({Key? key, required this.expenses}) : super(key: key);

  @override
  State<FancyPieChart> createState() => _FancyPieChartState();
}

class _FancyPieChartState extends State<FancyPieChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    final categoryTotals = <String, double>{};
    for (var e in widget.expenses) {
      categoryTotals[e.category] = (categoryTotals[e.category] ?? 0) + e.amount;
    }
    final total = categoryTotals.values.fold(0.0, (sum, e) => sum + e);

    final colors = [
      Color(0xFF9D4EDD), Color(0xFFF67280), Color(0xFF355C7D),
      Color(0xFF99B898), Color(0xFF00D2FF),
    ];
    int idx = 0;
    final pieSections = categoryTotals.entries.map((entry) {
      final percent = total == 0 ? 0 : (entry.value / total) * 100;
      final isTouched = idx == touchedIndex;
      final section = PieChartSectionData(
        color: colors[idx % colors.length],
        value: entry.value,
        title: "${percent.toStringAsFixed(1)}%",
        radius: isTouched ? 64 : 54,
        titleStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: isTouched ? 19 : 15,
          color: Colors.white,
        ),
      );
      idx++;
      return section;
    }).toList();

    return Container(
      height: 210,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: PieChart(
        PieChartData(
          sections: pieSections,
          centerSpaceRadius: 42,
          borderData: FlBorderData(show: false),
          sectionsSpace: 5,
          pieTouchData: PieTouchData(
            touchCallback: (event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = null;
                } else {
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                }
              });
            },
          ),
        ),
        swapAnimationDuration: Duration(milliseconds: 900),
        swapAnimationCurve: Curves.easeOutCubic,
      ),
    );
  }
}
