import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();

    analytics.pageView('Account');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的帳號'),
        centerTitle: true,
      ),
      body: Builder(builder: (context) {
        if (accountStorage.hasAnyAccount()) {
          return const AccountView();
        } else {
          return const Center(
            child: Text('您尚未新增任何帳號', style: TextStyle(fontSize: 30)),
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final accountCount = accountStorage.count;
          if (accountCount > 4) {
            showDialog(
                context: context,
                builder: (context) => CheckDialog(
                      message: '貼心小提醒，廢土伺服器同個 IP 只能同時登入 4 個帳號，您仍然要新增帳號嗎？',
                      onPressedOK: (context) {
                        showDialog(
                            context: context,
                            builder: (context) => const MicrosoftOauthDialog());
                      },
                    ));
          } else {
            showDialog(
                context: context,
                builder: (context) => const MicrosoftOauthDialog());
          }
        },
        tooltip: '新增帳號',
        child: const Icon(Icons.add),
      ),
    );
  }
}
