import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart';

class AccountView extends StatefulWidget {
  final void Function(Account account)? onSelect;

  const AccountView({Key? key, this.onSelect}) : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    final List<Account> accounts = _sortAccounts();

    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts[index];

        return ListTile(
          leading: account.getImage(width: 50, height: 50),
          title: Text(account.username, textAlign: TextAlign.center),
          subtitle: Text('UUID: ${account.uuid}', textAlign: TextAlign.center),
          trailing:
              widget.onSelect == null ? _actionWidget(account, context) : null,
          onTap: () {
            if (widget.onSelect != null) {
              widget.onSelect?.call(account);
            }
          },
        );
      },
    );
  }

  List<Account> _sortAccounts() {
    final accounts = accountStorage.getAll();

    final defaultAccount = accountStorage.getDefault();
    if (defaultAccount != null) {
      accounts.removeWhere((e) => e.uuid == defaultAccount.uuid);
      accounts.insert(0, defaultAccount);
    }

    return accounts;
  }

  Row _actionWidget(Account account, BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      IconButton(
        icon: Icon(Icons.bookmark,
            color: accountStorage.getDefault()?.uuid == account.uuid
                ? Colors.blue
                : null),
        tooltip: '設為預設帳號',
        onPressed: () {
          accountStorage.setDefault(account.uuid);
          setState(() {});
        },
      ),
      IconButton(
        icon: const Icon(Icons.delete),
        tooltip: '移除帳號',
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return CheckDialog(
                    message: '您確定要移除此帳號嗎？ (此動作將無法復原)',
                    onPressedOK: (context) {
                      Navigator.pop(context);
                      accountStorage.remove(account.uuid);
                      if (mounted) {
                        setState(() {});
                      }
                    });
              });
        },
      ),
    ]);
  }
}
