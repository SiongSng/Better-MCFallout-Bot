import 'dart:io';

import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ServerRegion region;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController warpPublicityController;
  late TextEditingController tradePublicityController;

  bool hidePassword = true;

  @override
  void initState() {
    region = appConfig.region;
    emailController = TextEditingController(text: appConfig.email);
    passwordController = TextEditingController(text: appConfig.password);
    warpPublicityController =
        TextEditingController(text: appConfig.warpPublicity);
    tradePublicityController =
        TextEditingController(text: appConfig.tradePublicity);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('機器人設定'),
      scrollable: true,
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 3.5,
        child: Column(
          children: [
            const Text('帳號設定', style: TextStyle(fontSize: 18)),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Minecraft 帳號',
                hintText: '請輸入 Microsoft 帳號 (Email)',
              ),
              controller: emailController,
              onChanged: (_) {
                appConfig.email = emailController.text;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Minecraft 密碼',
                  hintText: '請輸入 Microsoft 帳號的密碼',
                  suffixIcon: IconButton(
                      icon: Icon(hidePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      })),
              obscureText: hidePassword,
              controller: passwordController,
              onChanged: (_) {
                appConfig.password = passwordController.text;
              },
            ),
            const SizedBox(height: 12),
            const Text('伺服器設定', style: TextStyle(fontSize: 18)),
            ListTile(
              title: const Text("伺服器區域", style: TextStyle(fontSize: 16)),
              trailing: SizedBox(
                width: MediaQuery.of(context).size.width / 8,
                child: DropdownButton<ServerRegion>(
                  value: region,
                  style: const TextStyle(color: Colors.lightBlue),
                  onChanged: (ServerRegion? value) {
                    setState(() {
                      region = value!;
                    });
                    appConfig.region = region;
                  },
                  isExpanded: true,
                  items: ServerRegion.values
                      .map<DropdownMenuItem<ServerRegion>>(
                          (ServerRegion value) {
                    return DropdownMenuItem<ServerRegion>(
                      value: value,
                      alignment: Alignment.center,
                      child: Text(value.getName(),
                          style:
                              const TextStyle(fontSize: 16, fontFamily: 'font'),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                ),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '公共設施自動宣傳',
                hintText: '請輸入訊息 (範例格式：/warp <傳送點> <訊息>)',
              ),
              controller: warpPublicityController,
              onChanged: (_) {
                appConfig.warpPublicity = warpPublicityController.text;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '交易頻道自動宣傳',
                hintText: '請輸入訊息 (不用前綴，範例格式：<交易訊息>)',
              ),
              controller: tradePublicityController,
              onChanged: (_) {
                appConfig.tradePublicity = tradePublicityController.text;
              },
            ),
            const SizedBox(height: 12),
            const Text('其他設定', style: TextStyle(fontSize: 18)),
            ListTile(
              title: const Text('背景圖片', style: TextStyle(fontSize: 16)),
              subtitle: Builder(builder: (context) {
                if (appConfig.backgroundPath == null ||
                    !File(appConfig.backgroundPath!).existsSync()) {
                  return const Text('預設', style: TextStyle(fontSize: 16));
                } else {
                  return Text(appConfig.backgroundPath!,
                      overflow: TextOverflow.ellipsis);
                }
              }),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(type: FileType.image);
                        if (result != null && result.files.isNotEmpty) {
                          setState(() {
                            appConfig.backgroundPath = result.files.first.path;
                          });

                          showDialog(
                              context: context,
                              builder: (context) =>
                                  const BackgroundSuccessfulDialog());
                        }
                      },
                      child: const Text('選擇')),
                  const SizedBox(width: 8),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          appConfig.backgroundPath = null;
                        });

                        showDialog(
                            context: context,
                            builder: (context) =>
                                const BackgroundSuccessfulDialog());
                      },
                      child: const Text('恢復預設')),
                ],
              ),
            )
          ],
        ),
      ),
      actions: const [ConfirmButton()],
    );
  }
}
