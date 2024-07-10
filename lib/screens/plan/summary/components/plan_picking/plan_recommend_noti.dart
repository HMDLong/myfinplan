import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/screens/plan/summary/components/plan_picking/plan_picker_screen.dart';

class PlanRecommendNoti extends ConsumerWidget {
  const PlanRecommendNoti({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(recommendPlanProvider).when(
          data: (data) {
            final recommends = data.dists.where((dist) => data.recommendings.contains(dist.type));
            return Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: data.comments[0]),
                  ...recommends.map(
                    (dist) => TextSpan(
                      text: "${dist.title}, ",
                      style: const TextStyle(
                        color: CupertinoColors.activeBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextSpan(text: data.comments[1]),
                ],
              ),
            );
          },
          error: (error, _) {
            return const Text("Đã có lỗi xảy ra, thử lại nhé");
          },
          loading: () => const Text("Đang tính toán. Hãy chờ nhé!"),
        );
  }
}
