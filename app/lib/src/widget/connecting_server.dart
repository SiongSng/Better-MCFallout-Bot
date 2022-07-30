import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart';

class ConnectingServer extends StatefulWidget {
  const ConnectingServer({Key? key}) : super(key: key);

  @override
  State<ConnectingServer> createState() => _ConnectingServerState();
}

class _ConnectingServerState extends State<ConnectingServer> {
  @override
  void initState() {
    BotCore.createBot(
        host: appConfig.region.getHost(),
        port: 25565,
        email: appConfig.email!,
        password: appConfig.password!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: BotCore.instance!.connect(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            bool successful = snapshot.data!;
            if (successful) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BotStatusPage()));
              });

              return Container();
            } else {
              return const AlertDialog(
                title: Text('錯誤'),
                content: Text('無法連線到廢土伺服器\n請檢查帳號密碼是否正確，如果正確，請稍後再試。'),
                actions: [ConfirmButton()],
              );
            }
          } else {
            return AlertDialog(
              title: const Text('連線廢土伺服器中...'),
              content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [CircularProgressIndicator()]),
            );
          }
        });
  }
}
