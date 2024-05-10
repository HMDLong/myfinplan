// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:myfinplan/data/models/account/account.dart';
// import 'package:myfinplan/screens/plan/debts/components/provider/providers.dart';
// import 'package:myfinplan/shared_widgets/pickers/accounts_picker/account_bottom_sheet.dart';
// import 'package:myfinplan/utils/format.dart';
// import 'package:myfinplan/utils/time/times.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class AmortizingInfoSection extends ConsumerStatefulWidget {
//   const AmortizingInfoSection({super.key});

//   @override
//   ConsumerState<AmortizingInfoSection> createState() => _AmortizingInfoSectionState();
// }

// class PieChartData {
//   final String x;
//   final double y;
//   final Color color;

//   PieChartData(this.x, this.y, this.color);
// }

// class _AmortizingInfoSectionState extends ConsumerState<AmortizingInfoSection> {
//   _buildInfoTableRow(
//     String label,
//     String value, {
//     Color? indicate,
//     double valueSize = 12,
//     Color valueColor = Colors.black,
//   }) {
//     return Row(
//       children: [
//         if (indicate != null)
//           Expanded(
//             child: CircleAvatar(
//               radius: 6,
//               backgroundColor: indicate,
//             ),
//           ),
//         Expanded(
//           flex: 5,
//           child: Text(
//             label,
//             style: const TextStyle(fontSize: 12),
//           ),
//         ),
//         Expanded(
//           flex: 4,
//           child: Align(
//             alignment: Alignment.centerRight,
//             child: Text(
//               value,
//               style: TextStyle(fontSize: valueSize, color: valueColor),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Consumer(
//               builder: (BuildContext context, WidgetRef ref, Widget? child) {
//                 final selectedLoan = ref.watch(selectedLoanProvider);
//                 return Row(
//                   children: [
//                     SizedBox(
//                       height: 30,
//                       width: 30,
//                       child: FloatingActionButton.small(
//                         heroTag: 'change_loan_fab',
//                         backgroundColor: CupertinoColors.activeBlue,
//                         elevation: 4,
//                         onPressed: () async {
//                           final loan = await showModalBottomSheet(
//                             context: context,
//                             isScrollControlled: true,
//                             isDismissible: true,
//                             useSafeArea: true,
//                             shape: const RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(10.0),
//                               topRight: Radius.circular(10.0),
//                             )),
//                             builder: (context) {
//                               return const AccountBottomSheet(
//                                 onlyTypeOf: AccountType.loan,
//                               );
//                             },
//                           );
//                           ref.watch(selectedLoanProvider.notifier).state = loan;
//                         },
//                         child: const Icon(Icons.swap_horiz_outlined, size: 18),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Text(
//                       selectedLoan?.title ?? "Tất cả khoản nợ",
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 );
//               },
//             ),
//             const SizedBox(height: 10),
//             ref.watch(amortizingInfoProvider).when(
//                   data: (data) {
//                     final currentPaymentInfo = data.schedule[TimeRange.rangeByType(TimeType.month)]!.values;
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Card(
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
//                           color: Colors.blue.shade100,
//                           margin: EdgeInsets.zero,
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text.rich(
//                               TextSpan(
//                                 children: [
//                                   const TextSpan(text: "Với tiến độ hiện tại, dự kiến hết nợ vào "),
//                                   const TextSpan(text: "Th3 2026", style: TextStyle(fontWeight: FontWeight.bold)),
//                                   const TextSpan(text: ", sau "),
//                                   TextSpan(text: data.remainingPayTime, style: const TextStyle(fontWeight: FontWeight.bold)),
//                                   const TextSpan(text: " với "),
//                                   TextSpan(text: "${data.remainingPayMonth} tháng", style: const TextStyle(fontWeight: FontWeight.bold)),
//                                   const TextSpan(text: " trả kể từ tháng này"),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         SizedBox(
//                           height: 150,
//                           width: double.infinity,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 flex: 5,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     _buildInfoTableRow(
//                                       "Khoản mỗi tháng:",
//                                       amountToDecimal(data.monthMinPayment.toInt(), currency: null),
//                                       valueSize: 16,
//                                       valueColor: Colors.green,
//                                     ),
//                                     const SizedBox(height: 10),
//                                     _buildInfoTableRow(
//                                       "Tổng gốc:",
//                                       amountToDecimal(data.remainingPrincipal.toInt(), currency: null),
//                                       indicate: Colors.blue.shade900,
//                                     ),
//                                     _buildInfoTableRow(
//                                       "Tổng lãi",
//                                       amountToDecimal(data.remainingInterestPay.toInt(), currency: null),
//                                       indicate: Colors.blue.shade200,
//                                     ),
//                                     const Divider(thickness: 1),
//                                     _buildInfoTableRow(
//                                       "Tổng trả:",
//                                       amountToDecimal(data.remainingPay.toInt(), currency: null),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 4,
//                                 child: Align(
//                                   alignment: Alignment.centerRight,
//                                   child: SfCircularChart(
//                                     margin: const EdgeInsets.symmetric(horizontal: 4),
//                                     series: [
//                                       PieSeries<PieChartData, String>(
//                                         dataSource: [
//                                           PieChartData(
//                                             "Số gốc",
//                                             (currentPaymentInfo.principal / currentPaymentInfo.payment * 100).roundToDouble(),
//                                             Colors.blue.shade900,
//                                           ),
//                                           PieChartData(
//                                             "Số lãi",
//                                             (currentPaymentInfo.interest / currentPaymentInfo.payment * 100).roundToDouble(),
//                                             Colors.blue.shade200,
//                                           ),
//                                         ],
//                                         explode: true,
//                                         explodeIndex: 1,
//                                         xValueMapper: (datum, index) => datum.x,
//                                         yValueMapper: (datum, index) => datum.y,
//                                         pointColorMapper: (datum, index) => datum.color,
//                                         dataLabelMapper: (datum, index) => "${datum.y}%",
//                                         dataLabelSettings: const DataLabelSettings(
//                                           isVisible: true,
//                                           textStyle: TextStyle(fontSize: 12),
//                                           overflowMode: OverflowMode.shift,
//                                           labelPosition: ChartDataLabelPosition.inside,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Row(
//                           children: [
//                             Text.rich(
//                               TextSpan(
//                                 children: [
//                                   const TextSpan(text: "Cầu tuyết: "),
//                                   TextSpan(
//                                     text: amountToDecimal(0),
//                                     style: const TextStyle(fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const Tooltip(
//                               triggerMode: TooltipTriggerMode.tap,
//                               showDuration: Duration(seconds: 60),
//                               message: "",
//                             )
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Card(
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
//                           color: Colors.blue.shade100,
//                           margin: EdgeInsets.zero,
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text.rich(
//                               TextSpan(children: [
//                                 const TextSpan(text: "Với khoản trả thêm "),
//                                 TextSpan(text: amountToDecimal(1000000), style: const TextStyle(fontWeight: FontWeight.bold)),
//                                 const TextSpan(text: ", bạn sẽ tiết kiệm được "),
//                                 TextSpan(text: amountToDecimal(1000000), style: const TextStyle(fontWeight: FontWeight.bold)),
//                                 const TextSpan(text: " tiền lãi và rút ngắn thời gian trả nợ đi "),
//                                 const TextSpan(text: "3 tháng", style: TextStyle(fontWeight: FontWeight.bold)),
//                               ]),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                       ],
//                     );
//                   },
//                   error: (error, _) {
//                     return Text("$error");
//                   },
//                   loading: () => const CircularProgressIndicator(),
//                 ),
//             const SizedBox(height: 50),
//           ],
//         ),
//       ),
//     );
//   }
// }
