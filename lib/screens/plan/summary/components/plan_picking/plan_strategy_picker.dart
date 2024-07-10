import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/screens/plan/summary/components/plan_picking/strategy_explain_dialog.dart';
import 'package:myfinplan/services/plan/distributor/distributor.dart';
import 'package:myfinplan/screens/plan/summary/components/plan_picking/plan_picker_screen.dart';
import 'package:myfinplan/utils/strings.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class PlanStrategyPicker extends StatefulWidget {
  const PlanStrategyPicker({super.key});

  @override
  State<PlanStrategyPicker> createState() => _PlanStrategyPickerState();
}

class _PlanStrategyPickerState extends State<PlanStrategyPicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 6),
        const Text("Phân phối thu nhập"),
        const SizedBox(width: 4),
        SizedBox(
          width: 24,
          height: 24,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: Colors.blue.shade100,
              padding: EdgeInsets.zero,
            ),
            onPressed: openExplainDialog,
            child: const Icon(
              Icons.question_mark,
              color: CupertinoColors.activeBlue,
              size: 14,
            ),
          ),
        ),
        const SizedBox(width: 36),
        Expanded(
          child: GestureDetector(
            onTap: () {
              pushNewScreen(context, screen: const PlanPickerScreen());
            },
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: 30,
                width: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade800,
                      Colors.blue.shade500,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                  child: Center(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final currentDist = ref.watch(planDistProvider);
                        return Text(
                          currentDist.title,
                          style: const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void openExplainDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const DistributeExplainDialog();
      },
    );
  }
}
