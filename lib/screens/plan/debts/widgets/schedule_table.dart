import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/amortizing_info.dart';
import 'package:myfinplan/screens/plan/debts/components/provider/providers.dart';
import 'package:myfinplan/screens/plan/debts/debt_tab.dart';
import 'package:myfinplan/utils/format.dart';

class LoanScheduleTable extends ConsumerWidget {
  final SelectedContentState selectedContent;
  final LoanInfo info;
  const LoanScheduleTable({
    super.key,
    required this.info,
    required this.selectedContent,
  });

  Widget _cell(
    String text, {
    Color color = Colors.white,
    double height = heightPerCell,
    double width = widgetPerCell,
    bool isSelected = false,
    bool rightAlign = true,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints.expand(
          height: height,
          width: width,
        ),
        decoration: BoxDecoration(
          color: color,
          border: isSelected
              ? Border.all(
                  width: 1.0,
                  color: CupertinoColors.activeBlue,
                )
              : null,
        ),
        margin: const EdgeInsets.all(2.0),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Align(
            alignment: rightAlign ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              text,
              style: dataStyle,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final months = info.schedule.keys.toList()..sort((a, b) => a.compareTo(b));
    return SizedBox(
      height: heightPerCell * (info.loans.length + 1) + 8 * 2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [_cell("", height: headerHeight, width: loanHeaderWidth)] +
                info.loans
                    .map(
                      (e) => _cell(
                        e.title,
                        color: Colors.blue.shade200,
                        width: loanHeaderWidth,
                        isSelected: selectedContent.content == ContentType.loan && selectedContent.loanId == e.id,
                        onTap: () {
                          if (selectedContent.loanId == e.id) {
                            ref.read(loanSelectedContentProvider.notifier).state = SelectedContentState.init();
                          } else {
                            ref.read(loanSelectedContentProvider.notifier).state = selectedContent.copyWith(
                              content: ContentType.loan,
                              loanId: e.id,
                              month: null,
                            );
                          }
                        },
                      ),
                    )
                    .toList(),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                final month = months[index];
                return Container(
                  constraints: const BoxConstraints(
                    maxWidth: widgetPerCell,
                  ),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      if (i == 0) {
                        return _cell(
                          "${month.month}/${month.year}",
                          color: Colors.blue.shade200,
                          height: headerHeight,
                          isSelected: selectedContent.content == ContentType.month && selectedContent.month!.isAtSameMomentAs(month),
                          onTap: () {
                            if (selectedContent.month == month) {
                              ref.read(loanSelectedContentProvider.notifier).state = SelectedContentState.init();
                            } else {
                              ref.read(loanSelectedContentProvider.notifier).state = selectedContent.copyWith(
                                content: ContentType.month,
                                month: month,
                                loanId: null,
                              );
                            }
                          },
                        );
                      }
                      final entry = info.schedule[month]?[info.loans[i - 1].id];
                      return _cell(
                        Formatter.amountToDecimal(entry!.totalPayment.round(), currency: null),
                        color: i.remainder(2) == 0 ? Colors.grey.shade300 : Colors.white,
                      );
                    },
                    itemCount: info.loans.length + 1,
                  ),
                );
              },
              itemCount: months.length,
            ),
          ),
        ],
      ),
    );
  }
}
