import 'package:myfinplan/data/models/category/category/category.dart';

enum PlanTransactStatus {
  upcoming,
  late,
  paid,
  latePaid,
}

class PlanTransactDetail {
  Category category;
  int plan;
  int actual;

  PlanTransactDetail({
    required this.plan,
    required this.actual,
    required this.category,
  });
}
