import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinanceStatusBanner extends ConsumerStatefulWidget {
  const FinanceStatusBanner({super.key});

  @override
  ConsumerState<FinanceStatusBanner> createState() => _FinanceStatusBannerState();
}

class WarningInfo with EquatableMixin {
  int level;
  List<String> problems;

  WarningInfo({
    required this.level,
    required this.problems,
  });

  String get statusMessage => switch (level) {
        0 => "Tiến trình ổn định",
        1 => "Tiến trình lệch kế hoạch",
        2 => "Tiến trình mất cân bằng",
        3 => "Cảnh báo mất cân bằng thu chi",
        _ => "x",
      };

  List<Color> get statusColor => switch (level) {
        0 => [Colors.green.shade700, Colors.green.shade100],
        1 => [Colors.blue.shade700, Colors.blue.shade100],
        2 => [Colors.amber.shade700, Colors.amber.shade100],
        3 => [Colors.red.shade700, Colors.red.shade100],
        _ => throw "Unregconized level=$level",
      };

  IconData get statusIcon => switch (level) {
        0 => Icons.thumb_up_alt,
        1 => Icons.warning_amber_rounded,
        2 => Icons.thumb_down_alt,
        3 => Icons.warning_amber_rounded,
        _ => throw "Unregconized level=$level",
      };

  @override
  List<Object?> get props => [level, problems];
}

final bannerInfoProvider = FutureProvider((ref) async {
  return WarningInfo(
    level: 2,
    problems: [
      "Không đủ số dư để trả khoản vay mua xe (26/5)",
      "Không đủ số dư để trả khoản điện (27/5)",
      "Không đủ số dư để trả khoản vay mua xe (26/5)",
    ],
  );
  // return WarningInfo(
  //   level: 0,
  //   problems: [
  //     "Không có bất ổn được phát hiện",
  //   ],
  // );
});

double titleHeight = 50;
double problemHeight = 30;
double padding = 10;

class _FinanceStatusBannerState extends ConsumerState<FinanceStatusBanner> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(bannerInfoProvider).when(
          data: (data) {
            return SizedBox(
              height: titleHeight + data.problems.length * problemHeight + padding * 2,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                color: data.statusColor[1],
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding + 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            data.statusIcon,
                            color: data.statusColor[0],
                          ),
                          const SizedBox(width: 10),
                          Text(
                            data.statusMessage,
                            style: TextStyle(
                              color: data.statusColor[0],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...data.problems.map((e) => Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '\u2022  ',
                                  style: TextStyle(color: data.statusColor[0]),
                                ),
                                TextSpan(
                                  text: e,
                                  style: TextStyle(color: data.statusColor[0]),
                                ),
                              ],
                            ),
                            softWrap: true,
                          )),
                    ],
                  ),
                ),
              ),
            );
          },
          error: (error, _) {
            return SizedBox(
              height: 100,
              width: double.infinity,
              child: Center(
                child: Text("$error"),
              ),
            );
          },
          loading: () => const SizedBox(
            height: 100,
            width: double.infinity,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
  }
}
