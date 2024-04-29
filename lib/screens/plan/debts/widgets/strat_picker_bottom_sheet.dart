import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/plan/debt_strategy.dart';
import 'package:myfinplan/providers/plan/debt_strat.dart';

class StrategyPickerBottomSheet extends StatefulWidget {
  const StrategyPickerBottomSheet({super.key});

  @override
  State<StrategyPickerBottomSheet> createState() => _StrategyPickerBottomSheetState();
}

final debtStrategiesProvider = Provider<List<DebtStrategy>>((ref) {
  return [
    SnowballStrategy(),
    AvalancheStrategy(),
  ];
});

class _StrategyPickerBottomSheetState extends State<StrategyPickerBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          color: CupertinoColors.activeBlue,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Chọn 1 phương án",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final plans = ref.watch(debtStrategiesProvider);
              return ListView.separated(
                itemBuilder: (context, i) {
                  final plan = plans[i];
                  return GestureDetector(
                    onTap: () async {
                      await ref.read(currentDebtStratProvider.notifier).setStrat(plan).then(
                        (value) {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(width: 0.2),
                      ),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(plan.description, softWrap: true),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 5),
                itemCount: plans.length,
              );
            },
          ),
        ),
      ],
    );
  }
}
