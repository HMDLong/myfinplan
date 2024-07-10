import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myfinplan/data/models/category/transact_type/transaction_type.dart';

part 'base_category.g.dart';

@HiveType(typeId: 5)
class CustomIconData {
  @HiveField(0)
  int codePoint;
  @HiveField(1)
  String? fontFamily;
  @HiveField(2)
  String? fontPackage;

  CustomIconData(this.codePoint, {this.fontFamily, this.fontPackage});

  CustomIconData.fromMaterialIconData(IconData iconData)
      : codePoint = iconData.codePoint,
        fontFamily = iconData.fontFamily,
        fontPackage = iconData.fontPackage;

  IconData toMaterialIconData() => IconData(
        codePoint,
        fontFamily: fontFamily,
        fontPackage: fontPackage,
      );
}

abstract class BaseCategory {
  String get id;
  String get name;
  CustomIconData get icon;

  TransactionType get type => switch (id[0]) {
        'e' => TransactionType.expense,
        'i' => TransactionType.income,
        't' => TransactionType.transact,
        _ => throw Exception(),
      };

  List<Color> get color => switch (type) {
        TransactionType.expense => [Colors.red.shade600, Colors.red.shade100],
        TransactionType.income => [Colors.green.shade600, Colors.green.shade100],
        TransactionType.transact => [Colors.blue.shade600, Colors.blue.shade100],
      };

  /// check if [id] is a child [Category]
  static bool isChild(String id) => id.split(".").length > 1;
}
