import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/services/plan/distributor.dart';
import 'package:myfinplan/screens/plan/summary/components/plan_picking/plan_picker_screen.dart';
import 'package:myfinplan/utils/constants/strings.dart';
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
        const Expanded(child: Text("Phân phối thu nhập")),
        const SizedBox(),
        Tooltip(
          padding: const EdgeInsets.all(8),
          showDuration: const Duration(seconds: 30),
          triggerMode: TooltipTriggerMode.tap,
          message: planDistTooltipMessage,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            // color: Colors.blue,
            gradient: LinearGradient(colors: [
              CupertinoColors.activeBlue,
              Colors.blue.shade800,
            ]),
          ),
          child: const CircleAvatar(
            radius: 10,
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.question_mark,
              color: Colors.white,
              size: 12,
            ),
          ),
        ),
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
                child: Center(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final currentDist = ref.watch(planDistProvider);
                      return Text(
                        currentDist.title,
                        style: const TextStyle(color: Colors.white),
                      );
                      // FutureBuilder(
                      //   future: currentDist,
                      //   builder: (context, snapshot) {
                      //     return snapshot.connectionState == ConnectionState.waiting
                      //         ? const CircularProgressIndicator()
                      //         : snapshot.hasError
                      //             ? const Text("error")
                      //             : Text(
                      //                 snapshot.data!.title,
                      //                 style: const TextStyle(color: Colors.white),
                      //               );
                      //   },
                      // );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
