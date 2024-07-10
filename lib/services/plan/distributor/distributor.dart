import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/screens/plan/plan_screen.dart';
import 'package:myfinplan/services/plan/distributor/plan_distribution.dart';
import 'package:myfinplan/data/repositories/plan/plan_dist/plan_distribution_repo.dart';
import 'package:myfinplan/data/repositories/plan/plan_dist/plan_distribution_repo_impl.dart';
import 'package:myfinplan/services/transactions/transaction_notifier.dart';

final distributorProvider = FutureProvider((ref) async {
  final planTime = ref.watch(planTimeRangeProvider);
  final transacsts = (await ref.watch(transactionNotifierProvider).getAllTransaction()).where((e) => planTime.contain(e.timestamp));
  final schduledTransacts = await ref.watch(transactionNotifierProvider).getScheduledTransacts(range: planTime);
  final currentDist = ref.watch(planDistProvider);
});

final planDistProvider = StateNotifierProvider<PlanDistNotifier, PlanDistribution>((ref) {
  return PlanDistNotifier(ref.watch(planDistRepoProvider));
});

class PlanDistNotifier extends StateNotifier<PlanDistribution> {
  final PlanDistRepository repo;
  PlanDistNotifier(this.repo) : super(Distribution532()) {
    getDist();
  }

  /// Init on first app launch
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
