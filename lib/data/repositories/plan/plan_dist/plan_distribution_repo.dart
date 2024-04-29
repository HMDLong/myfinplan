import 'package:myfinplan/data/models/plan/plan_distribution.dart';

abstract class PlanDistRepository {
  Future<PlanDistribution> getCurrentDist();
  Future<bool> setCurrentDist(DistType dist);
}
