import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart';

class SelectAccount extends StatefulWidget {
  const SelectAccount({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectAccount> createState() => _SelectAccountState();
}

class _SelectAccountState extends State<SelectAccount> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('請選擇帳號'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.3,
        child: AccountView(
          onSelect: (account) {
            Navigator.pop(context);
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => ConnectingServer(account: account));
          },
        ),
      ),
      actions: const [ConfirmButton()],
    );
  }
}
