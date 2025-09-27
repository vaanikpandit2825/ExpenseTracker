import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';
import '../models/user_correction.dart';
import '../utils/message_parser.dart';

class PendingExpensesScreen extends StatefulWidget {
  const PendingExpensesScreen({super.key});

  @override
  State<PendingExpensesScreen> createState() => _PendingExpensesScreenState();
}

class _PendingExpensesScreenState extends State<PendingExpensesScreen> {
  late Box<Expense> expenseBox;

  @override
  void initState() {
    super.initState();
    expenseBox = Hive.box<Expense>('expenses');
  }

  // Save user correction
  void saveUserCorrection(String messageText, String newCategory) {
    final box = Hive.box<UserCorrection>('corrections');
    final pattern = extractKeyPattern(messageText);
    box.add(UserCorrection(pattern: pattern, category: newCategory));
  }

  String extractKeyPattern(String text) {
    final words = text.split(' ');
    return words.length > 3 ? '${words[0]} ${words[1]}' : text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Expenses')),
      body: ValueListenableBuilder(
        valueListenable: expenseBox.listenable(),
        builder: (context, Box<Expense> box, _) {
          final pending = box.values.where((e) => !e.confirmed).toList();
          if (pending.isEmpty) {
            return const Center(child: Text('No pending expenses'));
          }

          return ListView.builder(
            itemCount: pending.length,
            itemBuilder: (context, index) {
              final expense = pending[index];
              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  title: Text(
                    '₹${expense.amount} - ${expense.category}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    expense.note,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      // Edit category
                      showDialog(
                        context: context,
                        builder: (context) {
                          final controller =
                              TextEditingController(text: expense.category);
                          return AlertDialog(
                            title: const Text('Edit Category'),
                            content: TextField(
                              controller: controller,
                              decoration:
                                  const InputDecoration(labelText: 'Category'),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  final newCategory = controller.text.trim();
                                  if (newCategory.isNotEmpty) {
                                    setState(() {
                                      expense.category = newCategory;
                                      expense.save();
                                    });
                                    saveUserCorrection(expense.note, newCategory);
                                  }
                                  Navigator.pop(context);
                                },
                                child: const Text('Save'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}