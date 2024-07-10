import 'package:equatable/equatable.dart';
import 'package:myfinplan/data/models/category/category/category.dart';

class SummaryModel with EquatableMixin {
  Map<Level, double> plan;
  Map<Level, double> actual;

  SummaryModel({
    required this.plan,
    required this.actual,
  });

  @override
  List<Object?> get props => [];
}
