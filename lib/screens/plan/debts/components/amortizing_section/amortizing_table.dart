// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:myfinplan/data/models/account/amortizing_info.dart';
// import 'package:myfinplan/screens/plan/debts/components/provider/providers.dart';

// class AmortizingTable extends ConsumerStatefulWidget {
//   const AmortizingTable({super.key});

//   @override
//   ConsumerState<AmortizingTable> createState() => _AmortizingTableState();
// }

// final timeHeaderStyle = const TextStyle(
//   fontSize: 12,
//   fontWeight: FontWeight.w600,
// );

// class _AmortizingTableState extends ConsumerState<AmortizingTable> {
//   Widget _Cell(Widget child, {double? width}) {
//     return Tooltip(
//       message: "",
//       child: SizedBox(
//         height: 40,
//         width: width,
//         child: Padding(
//           padding: const EdgeInsets.all(4.0),
//           child: child,
//         ),
//       ),
//     );
//   }

//   _Headers(List<String> headersLabel) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: headersLabel.map((e) {
//         return _Cell(Text(e));
//       }).toList(),
//     );
//   }

//   Widget _DataRow(DateTime time, Map<String, AmortizingEntry> entries) {

//     final x = List<Widget>.generate(
//       entries.length,
//       (index) {
//         return 
//       },
//     );
//     return Column(
//       children: [
//             _Cell(
//               Text(
//                 "${time.month}/${time.year}",
//                 style: timeHeaderStyle,
//               ),
//             ),
//           ] + x,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ref.watch(amortizingInfoProvider).when(
//           data: (data) {
//             final schedule = data.schedule;
//             final months = schedule.keys.toList()
//               ..sort((a, b) {
//                 return a.compareTo(b);
//               });
//             return SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(""),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       _Headers([]),
//                       Expanded(
//                         child: ListView.separated(
//                           scrollDirection: Axis.horizontal,
//                           itemBuilder: (BuildContext context, int index) {
//                             final entryOfMonth = schedule[months[index]]!;
//                             return _DataRow(months[index], entryOfMonth);
//                           },
//                           separatorBuilder: (BuildContext context, int index) => const VerticalDivider(),
//                           itemCount: months.length,
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             );
//           },
//           error: (error, _) {
//             return Text("$error");
//           },
//           loading: () => const CircularProgressIndicator(),
//         );
//   }
// }
