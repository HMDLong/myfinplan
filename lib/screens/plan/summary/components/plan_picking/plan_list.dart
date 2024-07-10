import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/services/plan/distributor/plan_distribution.dart';
import 'package:myfinplan/screens/plan/summary/components/plan_picking/plan_picker_screen.dart';

class PlanList extends ConsumerWidget {
  final List<PlanDistribution> dists;
  final List<DistType> recommendings;
  const PlanList({
    super.key,
    required this.dists,
    this.recommendings = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPlan = ref.watch(pickedPlanProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: dists
          .map(
            (e) => GestureDetector(
              onTap: () {
                ref.read(pickedPlanProvider.notifier).state = e.type;
              },
              child: SizedBox(
                // height: 120,
                width: double.infinity,
                child: Card(
                  color: currentPlan == e.type ? Colors.green.shade100 : Colors.blue.shade100,
                  elevation: currentPlan == e.type ? 10 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(e.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(width: 8),
                            if (recommendings.contains(e.type))
                              Card(
                                elevation: 0,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Khuyến khích",
                                    style: TextStyle(
                                      color: currentPlan == e.type ? CupertinoColors.activeGreen : CupertinoColors.activeBlue,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(e.description),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
