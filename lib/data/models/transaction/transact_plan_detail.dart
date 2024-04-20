import 'package:hive_flutter/hive_flutter.dart';
import 'package:myfinplan/utils/random.dart';

part 'transact_plan_detail.g.dart';

@HiveType(typeId: 12)
class TransactPlanDetail with HiveObjectMixin {
  @HiveField(0)
  String planId;
  @HiveField(1)
  int planAmount;
  @HiveField(2)
  DateTime planTime;

  TransactPlanDetail({
    String? id,
    required this.planAmount,
    required this.planTime,
  }) : planId = id ?? getRandomKey();
}
