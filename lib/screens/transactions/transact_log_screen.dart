import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/screens/transactions/add_transaction/add_transaction_form_vm.dart';
import 'package:myfinplan/shared_widgets/pickers/timerange_picker/timerange_picker.dart';
import 'package:myfinplan/shared_widgets/transaction_list/transaction_list.dart';
import 'package:myfinplan/screens/transactions/add_transaction/add_transaction_screen.dart';
import 'package:myfinplan/screens/transactions/fliter_screen.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:myfinplan/utils/time/time_type.dart';
import 'package:myfinplan/utils/time/times.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class RecordScreen extends ConsumerStatefulWidget {
  const RecordScreen({super.key});

  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class FilterDetail {
  TimeRange timeRange;
  TransactionType? type;
  Account? fromAcc;
  Account? toAcc;
  String? categoryId;

  FilterDetail({
    TimeRange? timeRange,
    this.type,
    this.fromAcc,
    this.toAcc,
    this.categoryId,
  }) : timeRange = timeRange ?? TimeRange.rangeByType(TimeType.day);

  FilterDetail copyWith({
    TimeRange? timeRange,
    TransactionType? transactType,
    Account? fromAccount,
    Account? toAccount,
    String? categoryId,
  }) {
    return FilterDetail(
      timeRange: timeRange ?? this.timeRange,
      type: transactType ?? type,
      fromAcc: fromAccount ?? fromAcc,
      toAcc: toAccount ?? toAcc,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}

final filterDetailProvider = StateProvider((ref) => FilterDetail());

class _RecordScreenState extends ConsumerState<RecordScreen> {
  // late TimeRange timeRange;
  // TransactionType? type;
  // Account? fromAcc;
  // Account? toAcc;
  // String? categoryId;

  // @override
  // void initState() {
  //   timeRange = TimeRange.rangeByType(TimeType.day);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final filterDetail = ref.watch(filterDetailProvider);
    log("${filterDetail.timeRange}");
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "Các khoản thu chi",
        onBackPressed: () => Navigator.pop(context),
        trailings: [
          IconButton(
            onPressed: () {
              pushNewScreen(context, screen: const FilterScreen());
            },
            icon: const Icon(
              CupertinoIcons.slider_horizontal_3,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TimerangePicker(onTimeChanged: (value) {
            setState(() {
              ref.read(filterDetailProvider.notifier).state = filterDetail.copyWith(timeRange: value);
            });
          }),
          Expanded(
            child: TransactionList(
              timeRange: filterDetail.timeRange,
              transactType: filterDetail.type,
              account: filterDetail.fromAcc,
              categoryId: filterDetail.categoryId,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(addTransactFormVMProvider.notifier).reset();
          pushNewScreen(context, screen: const AddOrEditTransactScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
