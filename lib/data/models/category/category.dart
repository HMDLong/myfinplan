import 'package:hive_flutter/hive_flutter.dart';
import 'package:myfinplan/data/models/category/base_category.dart';
import 'package:myfinplan/utils/time/times.dart';
import 'transaction_type.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
class Category extends BaseCategory with HiveObjectMixin {
  @HiveField(0)
  @override
  String id;

  @HiveField(1)
  @override
  String name;

  @HiveField(2)
  @override
  CustomIconData icon;

  @HiveField(3)
  Budget? budget;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    this.budget,
  });

  String get parentId => id.split(".").first;

  static TransactionType getType(String categoryId) => switch (categoryId[0]) {
        'e' => TransactionType.expense,
        'i' => TransactionType.income,
        't' => TransactionType.transact,
        _ => throw Exception(),
      };

  // Category.fromJson(Map<String, dynamic> json)
  // : id = json['id'] as String,
  // name = json['name'] as String,
  // icon = CustomIconData.fromJson(json['icon'] as Map<String, dynamic>),
  // budget = json['budget'] == null
  // ? null
  // : Budget.fromJson(json['budget'] as Map<String, dynamic>);
}

@HiveType(typeId: 3)
class Budget {
  @HiveField(0)
  int amount;
  @HiveField(1)
  TimeRange period;
  @HiveField(2)
  bool isRecurrance;

  Budget({
    required this.amount,
    required this.period,
    this.isRecurrance = true,
  });

  // Budget.fromJson(Map<String, dynamic> json)
  // : amount = json['amount'], period = TimeRange.fronJson(json['period']), isRecurrance = json['is_recurrance'];
}
