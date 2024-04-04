import 'package:flutter/material.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/utils/random.dart';

class ParentCategory {
  String id;
  String name;
  IconData icon;

  ParentCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  TransactionType get type => switch (id[0]) {
        'e' => TransactionType.expense,
        'i' => TransactionType.income,
        't' => TransactionType.transact,
        _ => throw Exception(),
      };

  /// check if [categoryId] is this group's children
  bool hasChild(String categoryId) => categoryId.startsWith(id);

  static bool parentHasChild(String parentId, String childId) => childId.startsWith(parentId);

  /// create id for new child category
  String getNewChildId() => "$id.${getRandomKey()}";
}
