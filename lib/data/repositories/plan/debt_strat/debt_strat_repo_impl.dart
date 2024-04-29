import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/plan/debt_strategy.dart';
import 'package:myfinplan/data/repositories/plan/debt_strat/debt_strat_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

final debtStratRepoProvider = Provider((ref) => DebtStratRepositoryImpl());

class DebtStratRepositoryImpl extends DebtStratRepository {
  final futurePref = SharedPreferences.getInstance();
  final dataKey = "current_debt_strat";

  @override
  Future<DebtStrategy> getStrat() async {
    final pref = await futurePref;
    final data = pref.getString(dataKey);
    if (data == null) {
      return SnowballStrategy();
    }
    return DebtStrategy.fromTypeString(data);
  }

  @override
  Future<void> setStrat(DebtStrategy newStrat) async {
    final pref = await futurePref;
    await pref.setString(dataKey, newStrat.key);
  }
}
