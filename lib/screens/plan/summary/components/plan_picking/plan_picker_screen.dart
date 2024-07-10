import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/services/plan/distributor/plan_distribution.dart';
import 'package:myfinplan/screens/plan/summary/components/plan_picking/plan_list.dart';
import 'package:myfinplan/screens/plan/summary/components/plan_picking/plan_recommend_noti.dart';
import 'package:myfinplan/services/plan/distributor/distributor.dart';
import 'package:myfinplan/services/transactions/transaction_notifier.dart';
import 'package:myfinplan/utils/strings.dart';
import 'package:myfinplan/utils/styles.dart';

class PlanPickerScreen extends ConsumerStatefulWidget {
  const PlanPickerScreen({super.key});

  @override
  ConsumerState<PlanPickerScreen> createState() => _PlanPickerScreenState();
}

final plansProvider = Provider(
  (ref) => [
    Distribution532(),
    Distribution721(),
    Distribution82(),
  ],
);

class RecommendPlanModel {
  String firstSentece;
  String afterSenterce;
  List<PlanDistribution> dists;
  List<DistType> recommendings;

  RecommendPlanModel({
    this.firstSentece = "",
    this.afterSenterce = "",
    this.dists = const [],
    this.recommendings = const [],
  });

// return comments to display. A list of 2 string, first string is before the value
// second string is for after the value
  List<String> get comments {
    if (recommendings.isEmpty) {
      return [
        "Bạn mới bắt đầu? Vậy ",
        "sẽ là khởi đầu tốt đó!",
      ];
    }
    return ["Dựa vào thông số trước đây, bạn nên chọn ", ""];
  }
}

final recommendPlanProvider = FutureProvider<RecommendPlanModel>((ref) async {
  final plans = ref.watch(plansProvider);
  final transacts = await ref.watch(transactionNotifierProvider).getAllTransaction();
  // Find average must expenses, may expenses and saving of previous months
  final recommends = <DistType>[];
  for (var plan in plans) {
    if (plan.isSuitable(transacts)) {
      recommends.add(plan.type);
    }
  }
  return RecommendPlanModel(
    dists: plans,
    recommendings: recommends,
  );
});

final pickedPlanProvider = StateProvider<DistType>((ref) {
  return ref.watch(planDistProvider).type;
});

class _PlanPickerScreenState extends ConsumerState<PlanPickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyleRes.defaultStyledAppBar(
        title: StringRes.pickDistributeScreenTitle,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) {
                          return StyleRes.shimmerGradient(
                            colors: [
                              Colors.blue.shade300,
                              Colors.purple,
                              CupertinoColors.activeBlue,
                            ],
                          ).createShader(bounds);
                        },
                        child: const Icon(Icons.lightbulb),
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 6,
                    child: PlanRecommendNoti(),
                  ),
                ],
              ),
            ),
            Consumer(builder: (context, ref, child) {
              return ref.watch(recommendPlanProvider).when(
                data: (data) {
                  return PlanList(
                    dists: data.dists,
                    recommendings: data.recommendings,
                  );
                },
                error: (error, _) {
                  return SizedBox(
                    width: double.infinity,
                    height: 500,
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.red.shade200,
                          ),
                          const Text("Đã có lỗi xảy ra"),
                          const Text("Hãy thử lại"),
                        ],
                      ),
                    ),
                  );
                },
                loading: () {
                  return const SizedBox(
                    height: 500,
                    width: double.infinity,
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
      persistentFooterButtons: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CupertinoColors.activeBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final currentPlan = ref.read(pickedPlanProvider);
                  ref.read(planDistProvider.notifier).setDist(currentPlan).then((value) => Navigator.pop(context)).onError(
                    (error, stackTrace) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(CustomSnackbar.failure(StringRes.widgetErrorMessage));
                    },
                  );
                },
                child: const Text("Xác nhận"),
              ),
            ),
          ],
        )
      ],
    );
  }
}
