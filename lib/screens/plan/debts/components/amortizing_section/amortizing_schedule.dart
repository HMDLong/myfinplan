// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:myfinplan/screens/plan/debts/components/amortizing_section/amortizing_graph.dart';
// import 'package:myfinplan/screens/plan/debts/components/amortizing_section/amortizing_table.dart';
// import 'package:myfinplan/screens/plan/debts/components/amortizing_section/loan_picker_box.dart';
// import 'package:myfinplan/screens/plan/debts/components/provider/providers.dart';
// import 'package:myfinplan/utils/styles.dart';
// import 'package:myfinplan/utils/time/times.dart';

// class AmortizeSchedule extends ConsumerStatefulWidget {
//   const AmortizeSchedule({super.key});

//   @override
//   ConsumerState<AmortizeSchedule> createState() => _AmortizeScheduleState();
// }

// final selectedAmortizePeriodProvider = StateProvider((ref) => TimeRange.rangeByType(TimeType.month));

// class _AmortizeScheduleState extends ConsumerState<AmortizeSchedule> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: defaultStyledAppBar(
//         title: "",
//         onBackPressed: () => Navigator.of(context).pop(),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           LoanPickerBox(
//             onChange: (value) {
//               ref.read(selectedLoanProvider.notifier).state = value;
//             },
//           ),
//           const AmortizingGraph(),
//           const Expanded(child: AmortizingTable()),
//         ],
//       ),
//     );
//   }
// }
