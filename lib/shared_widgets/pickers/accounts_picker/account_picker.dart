import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/services/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/shared_widgets/pickers/accounts_picker/account_bottom_sheet.dart';
import 'package:myfinplan/utils/styles.dart';

class AccountPicker extends ConsumerStatefulWidget {
  final String? label;
  final void Function(Account value) onAccountChanged;
  final String? initialAccount;
  final bool payableOnly;
  const AccountPicker({
    super.key,
    this.label,
    required this.onAccountChanged,
    this.initialAccount,
    this.payableOnly = false,
  });

  @override
  ConsumerState<AccountPicker> createState() => _AccountPickerState();
}

class _AccountPickerState extends ConsumerState<AccountPicker> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    if (widget.initialAccount != null) {
      ref.read(accountsProvider).getAccountById(widget.initialAccount!).then((value) {
        _controller.text = value?.title ?? "";
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      decoration: StyleRes.formFieldDecor(
        icon: const Icon(Boxicons.bx_wallet),
        label: Text(widget.label ?? "Tài khoản nguồn"),
      ),
      onTap: () => _selectAccount(_controller, "sourceAcc"),
    );
  }

  void _selectAccount(TextEditingController controller, String fieldKey) async {
    Account? account = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        )),
        builder: (context) {
          return AccountBottomSheet(
            payableOnly: widget.payableOnly,
          );
        });

    if (account != null) {
      setState(() {
        widget.onAccountChanged(account);
        controller.text = account.title;
      });
    }
  }
}
