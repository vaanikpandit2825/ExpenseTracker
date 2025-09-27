import 'package:flutter/material.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  final Function(Expense) onAdd;

  const AddExpenseScreen({super.key, required this.onAdd});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _desc = TextEditingController();
  final _amount = TextEditingController();
  DateTime _date = DateTime.now();

  // Pick date
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF9D4EDD),
              onPrimary: Colors.white,
              surface: Colors.black,
              onSurface: Colors.white70,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _date = picked);
  }

  // Submit form
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final exp = Expense(
      note: _desc.text.trim(),          // user note
      amount: double.parse(_amount.text),
      date: _date,
      category: "Other",                // required field
      source: "Manual",                 // required field
    );

    widget.onAdd(exp);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _desc.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
        backgroundColor: const Color(0xFF121212),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _desc,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Enter a description" : null,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amount,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Amount (₹)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Enter an amount";
                  final n = double.tryParse(v);
                  if (n == null || n <= 0) return "Enter a valid number";
                  return null;
                },
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    "Date: ${_date.day}/${_date.month}/${_date.year}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _pickDate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9D4EDD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Pick Date"),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF88),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
