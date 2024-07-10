import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/screens/accounts/components/add_account_screen/add_account_screen.dart';
import 'package:myfinplan/screens/plan/savings/saving_tab_state.dart';
import 'package:myfinplan/shared_widgets/graphs/progress_gauge.dart';
import 'package:myfinplan/utils/strings.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class SavingTab extends ConsumerStatefulWidget {
  const SavingTab({super.key});

  @override
  ConsumerState<SavingTab> createState() => _SavingTabState();
}

class _SavingTabState extends ConsumerState<SavingTab> {
  @override
  Widget build(BuildContext context) {
    final savingData = ref.watch(savingTabStateProvider).when(
          data: (data) => data,
          error: (error, _) => SavingTabStateModel.empty(),
          loading: () => SavingTabStateModel.empty(),
        );
    final totalSaving = savingData.savings.fold(0, (prev, e) {
      return prev + e.amount;
    });
    final totalSavedThisRange = savingData.savedThisRange.fold(0, (prev, e) {
      return prev + e;
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: savingData.savings.isEmpty
            ? const SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(StringRes.noItemsMessage),
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
                      child: Text("Tổng tiết kiệm", style: TextStyle(fontSize: 12)),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        Formatter.amountToDecimal(totalSaving),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressGauge(
                      value: totalSavedThisRange,
                      max: savingData.totalNeedToSave,
                      mode: GaugeMode.goodOverflow,
                      showOverflow: true,
                      leadingLabel: "Đã tiết kiệm",
                      trailingLabel: "Dự kiến",
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.wallet),
                          SizedBox(width: 8),
                          Text("Các khoản tháng này"),
                        ],
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: savingData.savings.length,
                      itemBuilder: (BuildContext context, int index) {
                        final saving = savingData.savings[index];
                        final saved = savingData.savedThisRange[index];
                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text("${index + 1}"),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        saving.title,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        Formatter.amountToDecimal(saving.amount),
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      minWidth: 60,
                                    ),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.green.shade100,
                                    ),
                                    child: Text(
                                      "+ ${Formatter.amountToDecimal(saved, currency: null)}",
                                      style: TextStyle(
                                        color: Colors.green.shade600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                        // ListTile(
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(12),
                        //   ),
                        //   tileColor: Colors.blue.shade50,
                        //   key: Key(saving.id),
                        //   dense: true,
                        //   minLeadingWidth: 12,
                        //   title: Text(saving.title),
                        //   subtitle: Text(Formatter.amountToDecimal(saving.amount)),
                        //   leading: Text("${index + 1}"),
                        //   trailing: Container(
                        //     constraints: const BoxConstraints(
                        //       minWidth: 60,
                        //     ),
                        //     alignment: Alignment.center,
                        //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(12),
                        //       color: Colors.green.shade100,
                        //     ),
                        //     child: Text(
                        //       "+ ${Formatter.amountToDecimal(saved, currency: null)}",
                        //       style: TextStyle(
                        //         color: Colors.green.shade600,
                        //       ),
                        //     ),
                        //   ),
                        // );
                      },
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 2),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CupertinoColors.activeBlue,
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
