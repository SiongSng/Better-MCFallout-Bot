import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    analytics.pageView('Home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => const SettingsPage());
                },
                tooltip: '設定',
                icon: const Icon(Icons.settings)),
            IconButton(
              onPressed: () {
                Util.openUri('https://discord.gg/WJSnhPzcgs');
              },
              icon: const Icon(LineIcons.discord),
              tooltip: '更好的廢土機器人 Discord 社群',
            ),
            IconButton(
                onPressed: () async {
                  final dir = await getApplicationSupportDirectory();
                  Util.openFileManager(dir);
                },
                tooltip: '開啟資料儲存位置',
                icon: const Icon(Icons.folder)),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => const AboutPage());
                },
                tooltip: '關於',
                icon: const Icon(Icons.info))
          ],
        ),
        leadingWidth: 50 * 4,
        title: const Text('更好的廢土機器人'),
        centerTitle: true,
        actions: const [AccountManageButton()],
      ),
      body: Background(child: Container()),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (!accountStorage.hasAnyAccount()) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('錯誤'),
                        content: const Text('請先登入帳號才能讓機器人連線廢土伺服器'),
                        actions: [
                          ConfirmButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AccountPage()));
                            },
                          )
                        ],
                      ));
            } else {
              int count = accountStorage.count;

              if (count > 1) {
                showDialog(
                    context: context,
                    builder: (context) => const SelectAccount());
              } else {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => ConnectingServer(
                        account: accountStorage.getAll().first));
              }
            }
          },
          tooltip: '啟動機器人',
          child: const Icon(Icons.play_arrow)),
    );
  }
}
