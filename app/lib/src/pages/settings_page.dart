import 'dart:io';

import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  late TextEditingController allowTpaController;
  late TextEditingController attackIntervalTicksController;

  bool hidePassword = true;

  @override
  void initState() {
    region = appConfig.region;
    warpPublicityController =
        TextEditingController(text: appConfig.warpPublicity);
    tradePublicityController =
        TextEditingController(text: appConfig.tradePublicity);
    allowTpaController =
        TextEditingController(text: appConfig.allowTpa.join(','));
    attackIntervalTicksController =
        TextEditingController(text: appConfig.attackIntervalTicks.toString());

    super.initState();
    //analytics.pageView('Settings');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('機器人設定'),
      scrollable: true,
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 2.8,
        child: Column(
          children: [
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
            const Text('機器人設定', style: TextStyle(fontSize: 18)),
            Tooltip(
              message: '隱藏廢土伺服器中遊戲訊息會有的目標生命顯示，讓界面更加簡潔',
              child: SwitchListTile(
                  value: appConfig.hideHealth,
                  onChanged: (value) {
                    setState(() {
                      appConfig.hideHealth = value;
                    });
                  },
                  title: const Text('隱藏目標生命顯示')),
            ),
            Tooltip(
              message: '自動存入身上的綠寶石',
              child: SwitchListTile(
                value: appConfig.autoDeposit,
                onChanged:(value) {
                  setState(() {
                    appConfig.autoDeposit = value;
                  });
                },
                title: const Text('自動存入綠寶石'),
              )
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: '攻擊敵對生物冷卻時間 (tick)',
                  hintText: '單位為遊戲刻 (tick)，預設為 12'),
              controller: attackIntervalTicksController,
              onChanged: (value) {
                int? ticks = int.tryParse(value);
                if (ticks != null) {
                  appConfig.attackIntervalTicks = ticks;
                }
              },
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '公共設施自動宣傳',
                hintText: '請輸入訊息 (範例格式：「/warp <傳送點> <訊息內容>」)',
              ),
              controller: warpPublicityController,
              onChanged: (value) {
                if (value.isEmpty) {
                  appConfig.warpPublicity = null;
                  return;
                }
                appConfig.warpPublicity = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '交易頻道自動宣傳',
                hintText: '請輸入訊息 (不用前綴，範例格式：「收村 1:3w」)',
              ),
              controller: tradePublicityController,
              onChanged: (value) {
                if (value.isEmpty) {
                  appConfig.tradePublicity = null;
                  return;
                }
                appConfig.tradePublicity = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '自動接受 Tpa 請求白名單',
                hintText: '請輸入玩家 ID (如要多個請以 , 分隔，例如：「a,b,c」)',
              ),
              controller: allowTpaController,
              onChanged: (value) {
                if (value.isEmpty) {
                  appConfig.allowTpa = [];
                  return;
                }
                appConfig.allowTpa = value.split(',');
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

                          if (context.mounted) {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    const BackgroundSuccessfulDialog());
                          }
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
