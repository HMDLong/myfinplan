import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/domain/accounts/accounts/accounts_notifier.dart';
import 'package:provider/provider.dart';

class AccountBottomSheet extends ConsumerStatefulWidget {
  const AccountBottomSheet({super.key});

  @override
  ConsumerState<AccountBottomSheet> createState() => _AccountBottomSheetState();
}

class _AccountBottomSheetState extends ConsumerState<AccountBottomSheet> {
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
          const SizedBox(
            height: 10,
          ),
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
                      return ListView.builder(
                        itemCount: accounts.length,
                        itemBuilder: ((context, index) {
                          final account = accounts[index];
                          return GestureDetector(
                            onTap: () => Navigator.of(context).pop(account),
                            child: ListTile(
                              title: Text(account.title ?? "Tiền mặt"),
                              subtitle: Text(account.accountType.toText()),
                              trailing: Text("${account.amount}"),
                            ),
                          );
                        }),
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
