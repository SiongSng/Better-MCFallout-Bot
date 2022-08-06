import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart';

class ConnectingServer extends StatefulWidget {
  final Account account;
  final bool reconnect;
  final int reconnectTimes;

  const ConnectingServer(
      {Key? key,
      required this.account,
      this.reconnect = false,
      this.reconnectTimes = 0})
      : super(key: key);

  @override
  State<ConnectingServer> createState() => _ConnectingServerState();
}

class _ConnectingServerState extends State<ConnectingServer> {
  late final BotCore bot;

  @override
  void initState() {
    bot = BotCore.createBot(
        host: appConfig.region.getHost(),
        port: 25565,
        account: widget.account,
        reconnectTimes: widget.reconnectTimes);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reconnectTimes > 10) {
      return const AlertDialog(
        title: Text('錯誤'),
        content: Text('已嘗試重新連線超過 10 次，仍無法連線到伺服器，請稍後再試。\n如仍然失敗請聯繫作者'),
        actions: [ConfirmButton()],
      );
    } else {
      return FutureBuilder<bool>(
          future: bot.connect(),
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
                          builder: (context) => BotStatusPage(bot: bot)));
                });

                return Container();
              } else {
                return const AlertDialog(
                  title: Text('錯誤'),
                  content:
                      Text('無法連線到廢土伺服器\n請檢查帳號密碼是否正確，如果正確，請稍後再試。\n如仍然失敗請聯繫作者'),
                  actions: [ConfirmButton()],
                );
              }
            } else {
              return AlertDialog(
                title: widget.reconnect
                    ? const Text('由於與伺服器斷線，正在重新連線中...')
                    : const Text('連線廢土伺服器中...'),
                content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [CircularProgressIndicator()]),
              );
            }
          });
    }
  }
}
