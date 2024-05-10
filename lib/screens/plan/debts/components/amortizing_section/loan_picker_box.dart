// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:myfinplan/data/models/account/debt.dart';
// import 'package:myfinplan/screens/plan/debts/components/provider/providers.dart';
// import 'package:myfinplan/shared_widgets/pickers/accounts_picker/account_picker.dart';
// import 'package:myfinplan/utils/styles.dart';

// class LoanPickerBox extends ConsumerStatefulWidget {
//   final void Function(Loan value)? onChange;
//   const LoanPickerBox({
//     super.key,
//     this.onChange,
//   });

//   @override
//   ConsumerState<LoanPickerBox> createState() => _LoanPickerBoxState();
// }

// final loansListProvider = FutureProvider<List<Loan>>((ref) async {
//   return [];
// });

// class _LoanPickerBoxState extends ConsumerState<LoanPickerBox> {
//   @override
//   Widget build(BuildContext context) {
//     return ref.watch(loansListProvider).when(
//           data: (data) {
//             final selectedLoan = ref.watch(selectedLoanProvider);
//             return AccountPicker(
//               initAccountName: selectedLoan?.title,
//               onAccountChanged: (account) {
//                 ref.watch(selectedLoanProvider.notifier).state = account as Loan?;
//               },
//             );
//           },
//           error: (error, _) {
//             return Text("$error");
//           },
//           loading: () => const SizedBox.expand(
//             child: Center(
//               child: CircularProgressIndicator(),
//             ),
//           ),
//         );
//   }
// }
