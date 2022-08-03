import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart' hide NetworkImage;

class BotStatusPage extends StatefulWidget {
  const BotStatusPage({Key? key}) : super(key: key);

  @override
  State<BotStatusPage> createState() => _BotStatusPageState();
}

class _BotStatusPageState extends State<BotStatusPage> {
  late final BotCore bot;
  late bool autoEat;
  late bool autoThrow;
  late bool autoReconnect;
  late BotActionType botAction;
  late TextEditingController commandController;

  @override
  void initState() {
    bot = BotCore.instance!;

    autoEat = appConfig.autoEat;
    autoThrow = appConfig.autoThrow;
    autoReconnect = appConfig.autoReconnect;
    botAction = appConfig.botAction;

    commandController = TextEditingController();

    super.initState();

    if (botAction == BotActionType.raid) {
      bot.raid(BotActionMethod.start);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            bot.disconnect();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
          tooltip: '斷線',
        ),
        title: const Text('機器人狀態'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            const Text('基本資訊',
                style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('連線狀態：${bot.connected ? '已連線' : '未連線'}'),
                  Icon(bot.connected ? Icons.check_circle : Icons.error,
                      color: bot.connected ? Colors.green : Colors.red)
                ]),
            const SizedBox(height: 8),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NetworkImage(
                      src:
                          'https://crafatar.com/avatars/${bot.connectedData.uuid}?overlay',
                      width: 65,
                      height: 65),
                  const SizedBox(width: 12),
                  Text(bot.connectedData.name),
                  const SizedBox(width: 12),
                  const VerticalDivider(),
                  const SizedBox(width: 12),
                  SelectableText(
                      '連線位置：${bot.connectedData.host}\n通訊埠： ${bot.connectedData.port}\nUUID： ${bot.connectedData.uuid}\nMinecraft 遊戲版本：${bot.connectedData.gameVersion}'),
                ],
              ),
            ),
            const Divider(),
            StreamBuilder<StatusEvent>(
              stream: bot.whenEventStream<StatusEvent>(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  final data = snapshot.data!;

                  return IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const Text('狀態',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center),
                            const SizedBox(height: 8),
                            Tooltip(
                                message: data.health.toString(),
                                child: HealthIndicator(health: data.health)),
                            Tooltip(
                                message: data.food.toString(),
                                child: HungerIndicator(hunger: data.food)),
                            Text('遊戲時間：${Util.formatDuration(data.time)}'),
                          ],
                        ),
                        const SizedBox(width: 12),
                        const VerticalDivider(),
                        const SizedBox(width: 12),
                        Column(
                          children: [
                            const Tooltip(
                                message: '機器人的物品欄內容 (未按照實際位置編排)',
                                child: Text('物品欄',
                                    style: TextStyle(fontSize: 20))),
                            const SizedBox(height: 8),
                            InventoryView(items: data.inventoryItems)
                          ],
                        )
                      ],
                    ),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [CircularProgressIndicator()],
                  );
                }
              },
            ),
            const Divider(),
            Column(
              children: [
                const Text('機器人動作',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 9,
                  child: DropdownButton<BotActionType>(
                    value: botAction,
                    style: const TextStyle(color: Colors.lightBlue),
                    onChanged: (BotActionType? value) {
                      if (botAction != value) {
                        if (botAction == BotActionType.raid) {
                          bot.raid(BotActionMethod.stop);
                        } else if (value == BotActionType.raid) {
                          bot.raid(BotActionMethod.start);
                        }
                      }

                      setState(() {
                        botAction = value!;
                      });

                      appConfig.botAction = botAction;
                    },
                    isExpanded: true,
                    items: BotActionType.values
                        .where((e) => e.only)
                        .map<DropdownMenuItem<BotActionType>>(
                            (BotActionType value) {
                      return DropdownMenuItem<BotActionType>(
                        value: value,
                        alignment: Alignment.center,
                        child: Text(value.getName(),
                            style: const TextStyle(
                                fontSize: 16, fontFamily: 'font'),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('功能選擇',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: Tooltip(
                            message: '自動飲食，肉、蔬菜、湯都支援，可以防止餓死 (腐肉是黑名單)',
                            child: SwitchListTile(
                                value: autoEat,
                                onChanged: (value) {
                                  setState(() {
                                    autoEat = value;
                                  });
                                  appConfig.autoEat = autoEat;
                                  bot.updateConfig();
                                },
                                title: const Text('自動飲食')),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: Tooltip(
                            message:
                                '自動丟棄不重要的物品，保留重要物品，像是武器、不死圖騰、食物、裝備，在刷突襲塔的時候很有用。',
                            child: SwitchListTile(
                                value: autoThrow,
                                onChanged: (value) {
                                  setState(() {
                                    autoThrow = value;
                                  });
                                  appConfig.autoThrow = autoThrow;
                                  bot.updateConfig();
                                },
                                title: const Text('自動丟棄物品')),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: Tooltip(
                            message:
                                '自動重新連線伺服器，如果突然斷線或者廢土伺服器當機，會每 30 秒自動重新連線一次，若失敗超過 10 次則自動暫停。',
                            child: SwitchListTile(
                                value: autoReconnect,
                                onChanged: (value) {
                                  setState(() {
                                    autoReconnect = value;
                                  });
                                  appConfig.autoReconnect = autoReconnect;
                                  bot.updateConfig();
                                },
                                title: const Text('自動重新連線')),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            const Divider(),
            const Text('遊戲訊息',
                style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 300,
                  child: const GameMessageView()),
            ),
            const Divider(),
            const Text('執行指令',
                style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: TextField(
                    controller: commandController,
                    decoration: InputDecoration(
                        hintText: '請輸入指令',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onEditingComplete: () {
                      bot.runCommand(commandController.text);
                      commandController.text = '';
                    },
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                    onPressed: () {
                      bot.runCommand(commandController.text);
                      commandController.text = '';
                    },
                    child: const Text('執行')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
