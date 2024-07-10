import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/services/plan/debt_strategy/debt_strat.dart';
import 'package:myfinplan/screens/plan/debts/widgets/strat_picker_bottom_sheet.dart';

class StrategyPickerBox extends ConsumerWidget {
  const StrategyPickerBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Chiến lược quản lý", style: TextStyle(fontSize: 12)),
        InputChip(
          label: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final currentStrat = ref.watch(currentDebtStratProvider);
              return Text(currentStrat.title);
            },
          ),
          avatar: const Icon(
            Icons.swap_horiz_rounded,
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          side: const BorderSide(width: 0.5),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return const StrategyPickerBottomSheet();
              },
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              clipBehavior: Clip.antiAlias,
            );
          },
        )
      ],
    );
  }
}
