import 'dart:math';
import 'package:flutter/material.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  final Function(Expense) onAdd;
  final List<Expense> existingExpenses;
  final double currentBudget;

  const AddExpenseScreen({
    super.key,
    required this.onAdd,
    required this.existingExpenses,
    required this.currentBudget,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = "Food";

  final List<String> categories = ["Food", "Travel", "Bills", "Shopping", "Other"];

  final Map<String, List<String>> roastBank = {
    'Food': [
      "₹{amount}? You feeding your emotions again?",
      "₹{amount} on food? That’s not lunch, that’s a cry for help.",
      "Another food expense? You building a relationship with Swiggy?",
      "Bro, you eat like your stomach has no budget.",
      "₹{amount} for one meal? Michelin stars better be included.",
      "Your food budget died trying to keep up with your cravings.",
      "At this point, your kitchen exists only for decoration.",
      "You’ve spent enough on food to start a small restaurant.",
    ],
    'Travel': [
      "₹{amount}? You Ubered to another state?",
      "₹{amount} for travel? Bro, teleportation would’ve been cheaper.",
      "Are you collecting air miles or just regrets?",
      "Your wallet needs a break more than you do.",
      "₹{amount}? Were you traveling or relocating permanently?",
    ],
    'Bills': [
      "₹{amount} in bills? You powering a small city?",
      "Electricity bill that high? Did you start mining Bitcoin?",
      "Your water bill said ‘Hydrate less, my friend.’",
      "₹{amount} for Wi-Fi? NASA’s using your hotspot?",
    ],
    'Shopping': [
      "₹{amount}? That’s not retail therapy, that’s retail tragedy.",
      "₹{amount} on clothes? You changing outfits hourly now?",
      "You don’t shop — you financially blackmail yourself.",
      "That wasn’t a sale. That was bait.",
    ],
    'Other': [
      "₹{amount}? Your wallet just fainted.",
      "You really spent ₹{amount} on *that*? Bold move.",
      "You’re not spending — you’re speedrunning poverty.",
    ]
  };

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final expense = Expense(
      amount: double.parse(_amountController.text),
      description: _descController.text,
      date: _selectedDate,
      category: _selectedCategory,
    );

    widget.onAdd(expense);
    await _checkAndRoast(expense);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _checkAndRoast(Expense expense) async {
    final totalSpent = widget.existingExpenses
            .where((e) => e.category == expense.category)
            .fold<double>(0, (sum, e) => sum + e.amount) +
        expense.amount;

    final budget = widget.currentBudget;
    final spentPercent = budget > 0 ? (totalSpent / budget) * 100 : 0;

    String level;
    if (spentPercent > 120) level = "💣 Catastrophic";
    else if (spentPercent > 100) level = "💀 Inferno";
    else if (spentPercent > 75) level = "🔥 Heavy";
    else if (spentPercent > 50) level = "☕ Light";
    else level = "😎 Chill";

    final allRoasts = [
      ...?roastBank[expense.category],
      ...?roastBank['Other']
    ];
    final randomRoast = allRoasts[Random().nextInt(allRoasts.length)];
    final roastMessage =
        randomRoast.replaceAll("{amount}", expense.amount.toStringAsFixed(0));

    final prefix = switch (level) {
      "☕ Light" => "Slight burn 🔥",
      "🔥 Heavy" => "Budget meltdown alert",
      "💀 Inferno" => "Your finances are in hell now",
      "💣 Catastrophic" => "BOOM 💣",
      _ => "💸 Chill Spend"
    };

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, _, __) {
        return Center(
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: const Color(0xFF7E60FA),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    prefix,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    roastMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF7E60FA),
                      minimumSize: const Size(120, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "That hurts",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(scale: anim, child: child),
        );
      },
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter a description" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Enter an amount";
                  if (double.tryParse(v) == null) return "Enter a valid number";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    "Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: const Text("Pick Date"),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  "Add Expense",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
