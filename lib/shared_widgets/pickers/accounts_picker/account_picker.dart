import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/shared_widgets/pickers/accounts_picker/account_bottom_sheet.dart';
import 'package:myfinplan/utils/styles.dart';

class AccountPicker extends StatefulWidget {
  final String? label;
  final void Function(Account value) onAccountChanged;
  const AccountPicker({super.key, this.label, required this.onAccountChanged});

  @override
  State<AccountPicker> createState() => _AccountPickerState();
}

class _AccountPickerState extends State<AccountPicker> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _controller,
        readOnly: true,
        decoration: formFieldDecor(
          icon: const Icon(Boxicons.bx_wallet),
          label: Text(widget.label ?? "Tài khoản nguồn"),
        ),
        onTap: () => _selectAccount(_controller, "sourceAcc"),
      ),
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
          return const AccountBottomSheet();
        });

    if (account != null) {
      setState(() {
        widget.onAccountChanged(account);
        controller.text = account.title ?? "TM";
      });
    }
  }
}
