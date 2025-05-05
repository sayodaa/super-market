import 'package:hive/hive.dart';

part 'debt.g.dart';

@HiveType(typeId: 1)
class Debt extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String? note;

  @HiveField(3)
  final DateTime date;

  Debt({
    required this.name,
    required this.amount,
    this.note,
    required this.date,
  });
}
