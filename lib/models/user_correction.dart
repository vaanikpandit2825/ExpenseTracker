import 'package:hive/hive.dart';

part 'user_correction.g.dart';

@HiveType(typeId: 2)
class UserCorrection extends HiveObject {
  @HiveField(0)
  String pattern;

  @HiveField(1)
  String category;

  UserCorrection({required this.pattern, required this.category});
}
