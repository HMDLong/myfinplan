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
  @HiveField(3)
  bool cancelled;

  TransactPlanDetail({
    String? id,
    required this.planAmount,
    required this.planTime,
    this.cancelled = false,
  }) : planId = id ?? getRandomKey();

  TransactPlanDetail copyWith({
    DateTime? planTime,
    bool? cancelled,
  }) {
    return TransactPlanDetail(
      id: planId,
      planAmount: planAmount,
      planTime: planTime ?? this.planTime,
      cancelled: cancelled ?? this.cancelled,
    );
  }

  @override
  String toString() {
    return "Schedule{id:$planId}";
  }
}
