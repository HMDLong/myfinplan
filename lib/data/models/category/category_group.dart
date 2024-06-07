import 'package:equatable/equatable.dart';
import 'package:myfinplan/data/models/category/base_category.dart';
import 'package:myfinplan/utils/random.dart';

class ParentCategory extends BaseCategory with EquatableMixin {
  @override
  final String id;
  @override
  final String name;
  @override
  final CustomIconData icon;
  ParentCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  /// check if [childId] is child of [parentId]
  static bool parentHasChild(String parentId, String childId) => childId.startsWith(parentId);

  // /// check if [id] is a child [Category]
  // static bool isChild(String id) => id.split(".").length > 1;

  /// create id for new child category
  String getNewChildId() => "$id.${getRandomKey()}";

  /// check if [categoryId] is this group's children
  bool hasChild(String categoryId) => categoryId.startsWith(id);

  /// get parentId from [childId]
  static String parentIdFromChild(String childId) => childId.split(".").first;

  @override
  List<Object?> get props => [id];
}
