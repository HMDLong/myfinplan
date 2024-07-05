import 'package:hive/hive.dart';
import 'package:myfinplan/utils/time/recurrence.dart';

part 'plan_transaction.g.dart';

@HiveType(typeId: 100)
class PlanTransaction with HiveObjectMixin {
  @HiveField(0)
  String planId;
  @HiveField(1)
  String categoryId;
  @HiveField(2)
  int planAmount;
  @HiveField(3)
  String? from;
  @HiveField(4)
  String? to;
  @HiveField(5)
  String? description;
  @HiveField(6)
  String recurInfo;

  PlanTransaction({
    required this.planId,
    required this.categoryId,
    required this.planAmount,
    required this.recurInfo,
    this.from,
    this.to,
    this.description,
  });
}
