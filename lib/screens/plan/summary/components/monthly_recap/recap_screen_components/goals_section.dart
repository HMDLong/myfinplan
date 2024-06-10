import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/providers/providers.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/widgets/comment_card.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/widgets/recap_section_title.dart';
import 'package:myfinplan/utils/format.dart';

class GoalsSection extends ConsumerStatefulWidget {
  const GoalsSection({super.key});

  @override
  ConsumerState<GoalsSection> createState() => _GoalsSectionState();
}

const dataTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 12,
);

class _GoalsSectionState extends ConsumerState<GoalsSection> {
  Widget _infoRow(String label, String value, {bool fill = false}) {
    return Container(
      color: fill ? Colors.blue.shade100 : Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: dataTextStyle),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(value, style: dataTextStyle),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const RecapSectionTitle(title: "Mục tiêu & Tiết kiệm"),
        const SizedBox(height: 10),
        ...ref.watch(goalsDetailProvider).when<List<Widget>>(
              data: (data) {
                return [
                  _infoRow("Dự kiến", Formatter.amountToDecimal(1000000), fill: true),
                  _infoRow("Thực tế", Formatter.amountToDecimal(1000000)),
                  _infoRow("Tổng quỹ tiết kiệm", Formatter.amountToDecimal(1000000), fill: true),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 150,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 20,
                        horizontalMargin: 0,
                        dataRowMaxHeight: 30,
                        dataRowMinHeight: 20,
                        headingRowHeight: 25,
                        columns: [
                          const DataColumn(label: Text("")),
                          ...data.entries.map(
                            (e) => DataColumn(
                              label: Text("${e.account.title}", style: dataTextStyle),
                              numeric: true,
                            ),
                          ),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              const DataCell(
                                Text(
                                  "Tháng này",
                                  style: dataTextStyle,
                                ),
                              ),
                              ...data.entries.map(
                                (e) => DataCell(
                                  Text(
                                    "${e.thisMonthActualSaving}",
                                    style: dataTextStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              const DataCell(
                                Text(
                                  "Tiết kiệm",
                                  style: dataTextStyle,
                                ),
                              ),
                              ...data.entries.map(
                                (e) => DataCell(
                                  Text(
                                    "${e.account.amount}",
                                    style: dataTextStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              const DataCell(
                                Text(
                                  "Mục tiêu",
                                  style: dataTextStyle,
                                ),
                              ),
                              ...data.entries.map(
                                (e) => e.account.goal == null
                                    ? const DataCell(
                                        Text(""),
                                        placeholder: true,
                                      )
                                    : DataCell(
                                        Text(
                                          "${e.account.goal?.targetAmount}",
                                          style: dataTextStyle,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              const DataCell(
                                Text(
                                  "Tiến độ",
                                  style: dataTextStyle,
                                ),
                              ),
                              ...data.entries.map(
                                (e) => e.account.goal == null
                                    ? const DataCell(
                                        Text(""),
                                        placeholder: true,
                                      )
                                    : DataCell(
                                        Text(
                                          "${e.account.amount! * 100 / e.account.goal!.targetAmount!} %",
                                          style: dataTextStyle,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              error: (error, _) {
                return [
                  Text("$error"),
                ];
              },
              loading: () => [
                const SizedBox(height: 50, child: CircularProgressIndicator()),
              ],
            ),
        // CommentCard(
        //   child: Text(
        //     "Đây là tháng thứ 2 liên tiếp số dư tăng trưởng. Từ tháng 3/2024 (${amountToDecimal(100000000)}) đã tăng ${amountToDecimal(120530000 - 100000000)} (+20.53%).",
        //   ),
        // ),
      ],
    );
  }
}
