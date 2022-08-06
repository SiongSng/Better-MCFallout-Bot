import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart';

class AccountManageButton extends StatelessWidget {
  const AccountManageButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (accountStorage.hasAnyAccount()) {
      final account =
          accountStorage.getDefault() ?? accountStorage.getAll().first;

      return Tooltip(
        message: '管理帳號',
        child: InkResponse(
          radius: 40,
          highlightShape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          child: Row(
            children: [
              account.getImage(width: 30, height: 30),
              const SizedBox(width: 5),
              Text(account.username),
              const SizedBox(width: 10),
            ],
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AccountPage()));
          },
        ),
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.manage_accounts),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AccountPage()));
        },
        tooltip: '管理帳號',
      );
    }
  }
}
