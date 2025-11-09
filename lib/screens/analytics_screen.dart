import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/fancy_pie_chart.dart';
import '../widgets/fancy_bars_chart.dart';

class AnalyticsScreen extends StatelessWidget {
  final List<Expense> expenses;

  const AnalyticsScreen({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181733),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2F),
        title: const Text("Spending Analytics"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Card(
              elevation: 10,
              color: const Color(0xFF252242),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text("Expense Breakdown",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    FancyPieChart(expenses: expenses),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Card(
              elevation: 10,
              color: const Color(0xFF252242),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text("Spending by Category",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    FancyBarChart(expenses: expenses),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "💡 Tip: Spend smarter, not harder.",
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
