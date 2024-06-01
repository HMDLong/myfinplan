import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/plan/debt_strategy.dart';
import 'package:myfinplan/data/repositories/plan/debt_strat/debt_strat_repo.dart';
import 'package:myfinplan/data/repositories/plan/debt_strat/debt_strat_repo_impl.dart';

final currentDebtStratProvider = StateNotifierProvider<DebtStratNotifier, DebtStrategy>((ref) => DebtStratNotifier(ref.watch(debtStratRepoProvider)));

class DebtStratNotifier extends StateNotifier<DebtStrategy> {
  final DebtStratRepository _repo;
  DebtStratNotifier(this._repo) : super(AvalancheStrategy()) {
    getStrat();
  }

  void getStrat() async {
    try {
      final strat = await _repo.getStrat();
      state = strat;
    } catch (e) {
      log("$e");
    }
  }

  Future<void> setStrat(DebtStrategy newStrat) async {
    try {
      await _repo.setStrat(newStrat);
      getStrat();
    } catch (e) {
      log("$e");
    }
  }
}
