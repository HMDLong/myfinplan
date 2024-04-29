import 'package:myfinplan/data/models/plan/debt_strategy.dart';

abstract class DebtStratRepository {
  Future<DebtStrategy> getStrat();
  Future<void> setStrat(DebtStrategy newStrat);
}
