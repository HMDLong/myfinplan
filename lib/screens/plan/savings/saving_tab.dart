import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/screens/accounts/components/add_account_screen/add_account_screen.dart';
import 'package:myfinplan/screens/plan/savings/saving_tab_state.dart';
import 'package:myfinplan/shared_widgets/graphs/progress_gauge.dart';
import 'package:myfinplan/utils/constants/strings.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class SavingTab extends ConsumerStatefulWidget {
  const SavingTab({super.key});

  @override
  ConsumerState<SavingTab> createState() => _SavingTabState();
}

// final getSavingData = FutureProvider((ref) async {
//   final savings = (await ref.watch(accountsProvider).getAccountByType(AccountType.saving)).cast<Saving>();
//   return savings;
// });

class _SavingTabState extends ConsumerState<SavingTab> {
  @override
  Widget build(BuildContext context) {
    final savingData = ref.watch(savingTabStateProvider).when(
          data: (data) => data,
          error: (error, _) => SavingTabStateModel.empty(),
          loading: () => SavingTabStateModel.empty(),
        );
    final totalSaving = savingData.savings.fold(0, (prev, e) {
      return prev + e.amount!;
    });
    final totalSavedThisRange = savingData.savedThisRange.fold(0, (prev, e) {
      return prev + e;
    });
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: savingData.savings.isEmpty
            ? const SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(noItemsMessage),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Tổng tiết kiệm",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        amountToDecimal(totalSaving),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressGauge(
                      value: totalSavedThisRange,
                      max: 100000000,
                      mode: GaugeMode.goodOverflow,
                      showOverflow: true,
                      leadingLabel: "Đã tiết kiệm",
                      trailingLabel: "Dự kiến",
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(child: Icon(Icons.wallet)),
                            TextSpan(text: "Các khoản tháng này"),
                          ],
                        ),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: savingData.savings.length,
                      itemBuilder: (BuildContext context, int index) {
                        final saving = savingData.savings[index];
                        final saved = savingData.savedThisRange[index];
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor: Colors.blue.shade50,
                          key: Key(saving.id!),
                          dense: true,
                          minLeadingWidth: 12,
                          title: Text(saving.title!),
                          subtitle: Text(amountToDecimal(saving.amount!)),
                          leading: Text("${index + 1}"),
                          trailing: Text("+ ${amountToDecimal(saved, currency: null)}"),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(
                        height: 6,
                      ),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pushNewScreen(
            context,
            screen: const AddOrEditAccountScreen(initType: AccountType.saving),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
