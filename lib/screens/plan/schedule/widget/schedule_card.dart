import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';

import 'package:myfinplan/screens/plan/schedule/widget/status_box.dart';
import 'package:myfinplan/screens/transactions/add_transaction/add_transaction_screen.dart';
import 'package:myfinplan/screens/transactions/add_transaction/selected_transact_provider.dart';
import 'package:myfinplan/shared_widgets/button/round_icon_button.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

const detailStyle = TextStyle(
  fontSize: 12,
);

class ScheduleCard extends StatelessWidget {
  final Transaction schedule;
  const ScheduleCard({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    // final important = Random().nextBool();
    return ExpandableNotifier(
      child: ScrollOnExpand(
        child: Expandable(
          collapsed: ExpandableButton(
            child: _mainCard(
              isOpened: false,
              // important: important,
            ),
          ),
          expanded: _expandedCard(
            context,
            // important: important,
          ),
        ),
      ),
    );
  }

  Widget _mainCard({bool isOpened = false, bool important = false}) {
    return SizedBox(
      height: 80,
      child: Card(
        elevation: isOpened ? 6 : 0,
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          side: important
              ? const BorderSide(
                  color: CupertinoColors.activeBlue,
                  width: 0.5,
                )
              : BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 24, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(schedule.categoryName),
                    Text(Formatter.amountToDecimal(schedule.planDetail!.planAmount)),
                    if (schedule.srcAccId != null || schedule.toAccId != null)
                      Row(
                        children: [
                          Text(
                            schedule.srcAccName ?? "",
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                          const Icon(
                            Icons.keyboard_double_arrow_right_rounded,
                            size: 16,
                            color: Colors.grey,
                          ),
                          Text(
                            schedule.toAccName ?? "",
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        StatusBox(transact: schedule),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (important)
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
                  color: CupertinoColors.activeBlue,
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _expandedCard(BuildContext context, {bool important = false}) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Stack(
        children: [
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Colors.blue.shade50,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RoundedIconButton(
                          gradient: LinearGradient(
                            colors: important
                                ? [
                                    Colors.yellow,
                                    Colors.amber,
                                    Colors.deepOrange,
                                  ]
                                : [
                                    Colors.white,
                                    Colors.grey,
                                    Colors.grey.shade600,
                                  ],
                            stops: const [.4, .8, 1],
                          ),
                          backgroundColor: CupertinoColors.activeBlue,
                          icon: const Icon(Icons.star, size: 16),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        Consumer(
                          builder: (BuildContext context, WidgetRef ref, Widget? child) {
                            return RoundedIconButton(
                              icon: const Icon(Icons.edit_calendar_outlined, size: 16),
                              backgroundColor: CupertinoColors.activeBlue,
                              onPressed: () {
                                if (schedule.paid) {
                                  ref.read(selectedTransactionProvider.notifier).setTransact(schedule);
                                } else {
                                  ref.read(selectedTransactionProvider.notifier).setPlanTransact(schedule);
                                }
                                pushNewScreen(context, screen: AddOrEditTransactScreen(prefill: schedule));
                              },
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        RoundedIconButton(
                          icon: const Icon(Icons.playlist_remove_sharp, size: 16),
                          backgroundColor: CupertinoColors.activeBlue,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _row("", "Dự kiến", "Thực tế"),
                    _row(
                      "Số tiền",
                      Formatter.amountToDecimal(schedule.planDetail!.planAmount, currency: null),
                      Formatter.amountToDecimal(schedule.amount.abs(), currency: null),
                    ),
                    _row(
                      "Thời gian",
                      Formatter.toStandartDate(schedule.planDetail!.planTime),
                      Formatter.toStandartDate(schedule.planDetail!.planTime),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ExpandableButton(
            child: _mainCard(
              isOpened: true,
              important: important,
            ),
          ),
        ],
      ),
    );
  }

  _row(String title, String plan, String actual) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 50,
            child: Text(title, style: detailStyle, softWrap: true),
          ),
          SizedBox(
            width: 100,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(plan, style: detailStyle, softWrap: true),
            ),
          ),
          SizedBox(
            width: 100,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(actual, style: detailStyle, softWrap: true),
            ),
          ),
        ],
      ),
    );
  }
}
