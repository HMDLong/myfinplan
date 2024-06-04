import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/plan/plan_distribution.dart';
import 'package:myfinplan/data/repositories/plan/plan_dist/plan_distribution_repo.dart';
import 'package:myfinplan/data/repositories/plan/plan_dist/plan_distribution_repo_impl.dart';

final planDistProvider = StateNotifierProvider<PlanDistNotifier, PlanDistribution>((ref) {
  return PlanDistNotifier(ref.watch(planDistRepoProvider));
});

// class PlanDistNotifier extends ChangeNotifier {
//   final PlanDistRepository repo;

//   PlanDistNotifier(this.repo);

//   Future<void> init() async {
//     await repo.setCurrentDist(DistType.d532);
//   }

//   Future<bool> setCurrentDist(DistType dist) async {
//     final res = await repo.setCurrentDist(dist);
//     notifyListeners();
//     return res;
//   }

//   Future<PlanDistribution> getCurrentDist() {
//     return repo.getCurrentDist();
//   }
// }

class PlanDistNotifier extends StateNotifier<PlanDistribution> {
  final PlanDistRepository repo;
  PlanDistNotifier(this.repo) : super(Distribution532()) {
    getDist();
  }

  Future<void> init() async {
    await repo.setCurrentDist(DistType.d532);
    getDist();
  }

  void getDist() async {
    try {
      final dist = await repo.getCurrentDist();
      state = dist;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setDist(DistType dist) async {
    try {
      await repo.setCurrentDist(dist);
      getDist();
    } catch (e) {
      rethrow;
    }
  }
}
