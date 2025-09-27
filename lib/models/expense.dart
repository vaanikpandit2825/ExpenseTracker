import 'package:hive/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 1)
class Expense extends HiveObject {
  @HiveField(0)
  double amount;

  @HiveField(1)
  String category;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String note;

  @HiveField(4)
  String source;

  @HiveField(5)
  bool confirmed;

  Expense({
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
    required this.source,
    this.confirmed = false,
  });
}
