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
          showDialog(
              context: context,
              builder: (context) => const MicrosoftOauthDialog());
        },
        tooltip: '新增帳號',
        child: const Icon(Icons.add),
      ),
    );
  }
}
