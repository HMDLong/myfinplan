import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/utils/format.dart';

class AccountBottomSheet extends ConsumerStatefulWidget {
  final AccountType? onlyTypeOf;
  final bool payableOnly;
  const AccountBottomSheet({
    super.key,
    this.onlyTypeOf,
    this.payableOnly = false,
  });

  @override
  ConsumerState<AccountBottomSheet> createState() => _AccountBottomSheetState();
}

class _AccountBottomSheetState extends ConsumerState<AccountBottomSheet> with SingleTickerProviderStateMixin {
  late TabController controller;

  List<Tab> tabs() => AccountType.values.map((e) {
        return Tab(
          child: Text(
            e.toText(),
            style: TextStyle(
              color: widget.payableOnly && e == AccountType.loan ? Colors.grey : Colors.black,
            ),
          ),
        );
      }).toList();

  Widget _accountsList(List<Account> accounts) {
    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: ((context, index) {
        final account = accounts[index];
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(account),
          child: ListTile(
            title: Text(account.title),
            subtitle: Text(account.accountType.toText()),
            trailing: Text(Formatter.amountToDecimal(account.usableBalance)),
          ),
        );
      }),
    );
  }

  onTap() {
    if (!widget.payableOnly) {
      return;
    }
    final index = controller.previousIndex;
    if (AccountType.values[controller.index] == AccountType.loan) {
      controller.index = index;
    }
  }

  @override
  void initState() {
    controller = TabController(length: tabs().length, vsync: this)..addListener(onTap);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 40,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              color: Colors.blue,
            ),
            child: const Text(
              "Chọn tài khoản",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          TabBar.secondary(
            controller: controller,
            tabs: tabs(),
            isScrollable: true,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder(
                future: ref.watch(accountsProvider).getAllAccount(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return const CircularProgressIndicator();
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return const SizedBox.expand(
                          child: Text("Đã có lỗi xảy ra"),
                        );
                      }
                      final accounts = snapshot.data ?? [];
                      if (widget.onlyTypeOf != null) {
                        accounts.retainWhere((e) => e.accountType == widget.onlyTypeOf);
                      }
                      return TabBarView(
                        controller: controller,
                        children: AccountType.values.map((type) {
                          return _accountsList(accounts.where((acc) => acc.accountType == type).toList());
                        }).toList(),
                      );
                    case _:
                      return const CircularProgressIndicator();
                  }
                }),
          )
        ],
      ),
    );
  }
}
