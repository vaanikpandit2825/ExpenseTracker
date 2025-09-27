import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/expense.dart';
import 'models/user_correction.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'utils/message_parser.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive setup
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(UserCorrectionAdapter());
  await Hive.openBox<Expense>('expenses');
  await Hive.openBox<UserCorrection>('corrections');

  // Notification listener (Android only)
  if (Platform.isAndroid) {
    final service = NotificationListenerService.instance;
    service.start();
    setupNotificationListener(service);
  }

  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Smart Expense Tracker',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF88),
          secondary: Color(0xFF9D4EDD),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// Notification listener logic
void setupNotificationListener(NotificationListenerService service) {
  service.notificationStream.listen((notification) async {
    final sender = notification.packageName ?? 'Unknown';
    final text = notification.text ?? '';

    if (MessageParser.isBankMessage(sender, text)) {
      final amount = MessageParser.extractAmount(text) ?? 0.0;
      final category = MessageParser.mapCategory(text);
      final type = MessageParser.detectType(text);

      if (type == TxnType.expense) {
        final box = Hive.box<Expense>('expenses');
        await box.add(Expense(
          amount: amount,
          category: category,
          date: DateTime.now(),
          note: text,
          source: sender,
          confirmed: false,
        ));

        // Show snack bar with review option
        ScaffoldMessenger.of(navigatorKey.currentState!.overlay!.context)
            .showSnackBar(SnackBar(
          content:
              Text('New pending expense: ₹$amount in $category from $sender'),
          action: SnackBarAction(
            label: 'Review',
            onPressed: () {
              Navigator.push(
                  navigatorKey.currentState!.context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()));
            },
          ),
        ));
      }
    }
  });
}
