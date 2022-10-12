import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final TextStyle titleStyle = const TextStyle(fontSize: 20);
  String version = '';

  @override
  void initState() {
    super.initState();

    getVersion();
    analytics.pageView('About');
  }

  getVersion() async {
    version = await Util.getAppVersion();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('關於本軟體'), centerTitle: true),
      body: ListView(
        children: [
          const SizedBox(
            height: 12,
          ),
          Text('本軟體主要使用的技術\nFlutter\nNode.js\nMineflayer\nTypescript\nDart',
              style: titleStyle, textAlign: TextAlign.center),
          Text('版本：$version', style: titleStyle, textAlign: TextAlign.center),
          Text('主要開發者：菘菘', style: titleStyle, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          const Text('連結',
              style: TextStyle(fontSize: 25, color: Colors.blue),
              textAlign: TextAlign.center),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Util.openUri('https://rpmtw.com');
                },
                icon: const Icon(LineIcons.home),
                tooltip: 'RPMTW 社群官網',
              ),
              IconButton(
                onPressed: () {
                  Util.openUri(
                      'https://github.com/SiongSng/Better-MCFallout-Bot');
                },
                icon: const Icon(LineIcons.github),
                tooltip: 'GitHub',
              ),
              IconButton(
                onPressed: () {
                  Util.openUri('https://discord.gg/WJSnhPzcgs');
                },
                icon: const Icon(LineIcons.discord),
                tooltip: '更好的廢土機器人 Discord 社群',
              ),
              IconButton(
                icon: const Icon(Icons.book_outlined),
                onPressed: () {
                  showLicensePage(
                    applicationName: 'Better MCFallout Bot',
                    applicationVersion: version,
                    context: context,
                  );
                },
                tooltip: '顯示開源函式庫授權條款',
              ),
            ],
          ),
        ],
      ),
      persistentFooterButtons: const [
        Center(
          child: Text(
              'Copyright © SiongSng 2022 All Right Reserved.\nNOT AN OFFICIAL MINECRAFT PRODUCT. NOT APPROVED BY OR ASSOCIATED WITH MOJANG.',
              textAlign: TextAlign.center),
        )
      ],
    );
  }
}
