import 'package:myfinplan/services/plan/debt_strategy/debt_strategy.dart';

abstract class DebtStratRepository {
  Future<DebtStrategy> getStrat();
  Future<void> setStrat(DebtStrategy newStrat);
}
