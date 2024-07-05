import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/plan/plan_distribution.dart';
import 'package:myfinplan/services/plan/distributor.dart';
import 'package:myfinplan/utils/constants/strings.dart';
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

class _PlanPickerScreenState extends ConsumerState<PlanPickerScreen> {
  late DistType currentPlan;

  @override
  void initState() {
    currentPlan = ref.read(planDistProvider).type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final plans = ref.watch(plansProvider);

    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "",
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: plans
            .map((e) => GestureDetector(
                  onTap: () {
                    setState(() {
                      currentPlan = e.type;
                    });
                  },
                  child: SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: currentPlan == e.type ? CupertinoColors.activeBlue : Colors.grey.shade300,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text(e.description),
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
      persistentFooterButtons: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ref.read(planDistProvider.notifier).setDist(currentPlan).then((value) => Navigator.pop(context)).onError(
                    (error, stackTrace) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(CustomSnackbar.failure(widgetErrorMessage));
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
