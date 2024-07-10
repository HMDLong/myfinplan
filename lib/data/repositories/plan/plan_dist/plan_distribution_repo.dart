import 'package:myfinplan/services/plan/distributor/plan_distribution.dart';

abstract class PlanDistRepository {
  Future<PlanDistribution> getCurrentDist();
  Future<bool> setCurrentDist(DistType dist);
}
