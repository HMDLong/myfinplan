import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/domain/plan/distributor.dart';
import 'package:myfinplan/presentation/plan/summary/components/plan_picking/plan_picker_screen.dart';
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
        Expanded(
          child: Text("Phân phối thu nhập"),
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
                      final currentDist = ref.watch(planDistNotifierProvider).getCurrentDist();
                      return FutureBuilder(
                        future: currentDist,
                        builder: (context, snapshot) {
                          return snapshot.connectionState == ConnectionState.waiting
                              ? const CircularProgressIndicator()
                              : snapshot.hasError
                                  ? const Text("error")
                                  : Text(
                                      snapshot.data!.title,
                                      style: const TextStyle(color: Colors.white),
                                    );
                        },
                      );
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
