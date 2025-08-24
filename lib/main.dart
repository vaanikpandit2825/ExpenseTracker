import 'package:flutter/widgets.dart';
import 'screens/HomeScreen.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: const Color(0xFFF5F7FA), // app bg
      builder: (context, child) => const HomeScreen(),
    );
  }
}
