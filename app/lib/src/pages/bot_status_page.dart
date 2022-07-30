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
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NetworkImage(
                      src:
                          "https://crafatar.com/avatars/${bot.connectedData!.uuid}?overlay",
                      width: 65,
                      height: 65),
                  const SizedBox(width: 12),
                  Text(bot.connectedData!.name),
                  const SizedBox(width: 12),
                  const VerticalDivider(),
                  const SizedBox(width: 12),
                  SelectableText(
                      '連線位置：${bot.connectedData!.host}\n通訊埠： ${bot.connectedData!.port}\nUUID： ${bot.connectedData!.uuid}\nMinecraft 遊戲版本：${bot.connectedData!.gameVersion}'),
                ],
              ),
            ),
            const Divider(),
            const Text('狀態',
                style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            StreamBuilder<StatusEvent>(
              stream: bot.whenEventStream<StatusEvent>(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  final data = snapshot.data!;

                  return Column(
                    children: [
                      Tooltip(
                          message: data.health.toString(),
                          child: HealthIndicator(health: data.health)),
                      Tooltip(
                          message: data.food.toString(),
                          child: HungerIndicator(hunger: data.food)),
                      Text('遊戲時間：${Util.formatDuration(data.time)}'),
                      const Divider(),
                      const Tooltip(
                          message: '機器人的物品欄內容 (未按照實際位置編排)',
                          child: Text('物品欄', style: TextStyle(fontSize: 20))),
                      const SizedBox(height: 8),
                      InventoryView(items: data.inventoryItems)
                    ],
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
            const Text('機器人動作',
                style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            Align(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 5.5,
                child: DropdownButton<BotActionType>(
                  value: botAction,
                  style: const TextStyle(color: Colors.lightBlue),
                  onChanged: (BotActionType? value) {
                    setState(() {
                      botAction = value!;
                    });
                    appConfig.botAction = botAction;
                  },
                  isExpanded: true,
                  items: BotActionType.values
                      .where((e) => e != BotActionType.command)
                      .map<DropdownMenuItem<BotActionType>>(
                          (BotActionType value) {
                    return DropdownMenuItem<BotActionType>(
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
            const Divider(),
            const Text('功能選擇',
                style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Tooltip(
              message: '自動飲食，肉、蔬菜、湯都支援，可以防止餓死',
              child: SwitchListTile(
                  value: autoEat,
                  onChanged: (value) {
                    setState(() {
                      autoEat = value;
                    });
                    appConfig.autoEat = autoEat;
                  },
                  title: const Text('自動飲食')),
            ),
            Tooltip(
              message: '自動丟棄不重要的物品，保留重要物品，像是劍、不死圖騰、裝備，在刷突襲塔的時候很有用。',
              child: SwitchListTile(
                  value: autoThrow,
                  onChanged: (value) {
                    setState(() {
                      autoThrow = value;
                    });
                    appConfig.autoThrow = autoThrow;
                  },
                  title: const Text('自動丟棄物品')),
            ),
            Tooltip(
              message:
                  '自動重新連線伺服器，如果突然斷線或者廢土伺服器當機，會每 30 秒自動重新連線一次，若失敗超過 10 次則自動暫停。',
              child: SwitchListTile(
                  value: autoReconnect,
                  onChanged: (value) {
                    setState(() {
                      autoReconnect = value;
                    });
                    appConfig.autoReconnect = autoReconnect;
                  },
                  title: const Text('自動重新連線')),
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
                    onEditingComplete: () =>
                        bot.runCommand(commandController.text),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                    onPressed: () => bot.runCommand(commandController.text),
                    child: const Text('執行')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
