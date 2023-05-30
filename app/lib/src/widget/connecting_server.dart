import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart';

class ConnectingServer extends StatefulWidget {
  final Account account;
  final bool reconnect;
  final int reconnectTimes;
  final String disconnectReason;

  const ConnectingServer(
      {Key? key,
      required this.account,
      this.reconnect = false,
      this.reconnectTimes = 0,
      this.disconnectReason="None"})
      : super(key: key);

  @override
  State<ConnectingServer> createState() => _ConnectingServerState();
}

class _ConnectingServerState extends State<ConnectingServer> {
  @override
  void initState() {
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
      return FutureBuilder(
          future: MicrosoftOauthHandler.validate(widget.account)
              .timeout(const Duration(seconds: 15), onTimeout: () => false),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              // if the token is expired and refresh it failed
              if (!snapshot.data) {
                return AlertDialog(
                  title: const Text('錯誤'),
                  content: const Text('偵測到您的帳號憑證已過期'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) =>
                                  const MicrosoftOauthDialog());
                        },
                        child: const Text('重新登入'))
                  ],
                );
              } else {
                final bot = BotCore.createBot(
                    region: appConfig.region,
                    port: 25565,
                    // Get the refreshed credential account
                    account: accountStorage.get(widget.account.uuid)!,
                    reconnectTimes: widget.reconnectTimes);

                return _Connecting(bot: bot, reconnect: widget.reconnect,disconnectReason: widget.disconnectReason);
              }
            } else {
              return AlertDialog(
                title: const Text('正在檢查帳號憑證是否有效...'),
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

class _Connecting extends StatelessWidget {
  const _Connecting({
    Key? key,
    required this.bot,
    required this.reconnect,
    this.disconnectReason="None"
  }) : super(key: key);

  final BotCore bot;
  final bool reconnect;
  final String disconnectReason;

  @override
  Widget build(BuildContext context) {
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
              title: reconnect
                  ? Text('由於與伺服器斷線，正在重新連線中...\n(斷線原因:$disconnectReason)')
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
