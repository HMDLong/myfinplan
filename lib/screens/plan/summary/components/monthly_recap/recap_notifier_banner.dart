import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/monthly_recap_screen.dart';
import 'package:myfinplan/utils/strings.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class PlanValuateNotifierBanner extends StatelessWidget {
  const PlanValuateNotifierBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushNewScreen(context, screen: const PlanUpdateScreen());
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        constraints: const BoxConstraints(minHeight: 60),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade900,
              CupertinoColors.activeBlue,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Row(
          children: [
            Expanded(
              child: Icon(
                Icons.lightbulb_sharp,
                color: Colors.white,
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                StringRes.planEvaluateBannerContent,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
