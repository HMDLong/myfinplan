import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/plan/plan_distribution.dart';
import 'package:myfinplan/providers/plan/distributor.dart';
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
  DistType currentPlan = DistType.d532;

  @override
  Widget build(BuildContext context) {
    final plans = ref.watch(plansProvider);
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "",
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: FutureBuilder(
        future: ref.watch(planDistNotifierProvider).getCurrentDist(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return Column(
            children: plans
                .map((e) => GestureDetector(
                      onTap: () {
                        setState(() {
                          currentPlan = e.type;
                        });
                      },
                      child: SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                              color: currentPlan == e.type ? CupertinoColors.activeBlue : Colors.transparent,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(e.title),
                                Text(e.description),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          );
        },
      ),
      persistentFooterButtons: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ref.read(planDistNotifierProvider.notifier).setCurrentDist(currentPlan).then((value) => Navigator.pop(context)).onError(
                    (error, stackTrace) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(CustomSnackbar.failure(widgetErrorMessage));
                    },
                  );
                },
                child: Text("Xác nhận"),
              ),
            ),
          ],
        )
      ],
    );
  }
}
