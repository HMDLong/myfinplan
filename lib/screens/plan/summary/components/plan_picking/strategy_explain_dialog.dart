import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfinplan/utils/strings.dart';

class DistributeExplainDialog extends StatelessWidget {
  const DistributeExplainDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text("Phân bổ thu nhập"),
      content: SizedBox(
        width: 200,
        child: Text(
          StringRes.planDistTooltipMessage,
          softWrap: true,
        ),
      ),
    );
  }
}
