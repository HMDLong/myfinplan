import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/services/plan/distributor/plan_distribution.dart';
import 'package:myfinplan/data/repositories/plan/plan_dist/plan_distribution_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

final planDistRepoProvider = Provider((ref) => PlanDistRepositoryImpl());

class PlanDistRepositoryImpl extends PlanDistRepository {
  final futurePref = SharedPreferences.getInstance();
  final dataKey = "current_distribution";

  @override
  Future<PlanDistribution> getCurrentDist() async {
    final pref = await futurePref;
    final type = pref.getString(dataKey);
    if (type == null) {
      return Distribution532();
    }
    return PlanDistribution.fromType(type);
  }

  @override
  Future<bool> setCurrentDist(DistType dist) async {
    final pref = await futurePref;
    return pref.setString(dataKey, dist.toString());
  }
}
