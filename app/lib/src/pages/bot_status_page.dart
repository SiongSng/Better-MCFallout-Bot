import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:better_mcfallout_bot/src/widget/experience_indicator.dart';
import 'package:flutter/material.dart' hide NetworkImage;
import 'package:logging/logging.dart';

final Logger _logger = Logger('bot_status_page');

class BotStatusPage extends StatefulWidget {
  final BotCore bot;

  const BotStatusPage({Key? key, required this.bot}) : super(key: key);

  @override
  State<BotStatusPage> createState() => _BotStatusPageState();
}

class _BotStatusPageState extends State<BotStatusPage> {
  late bool autoEat;
  late bool autoThrow;
  late bool autoReconnect;
  late bool autoDeposit;
  late BotActionType botAction;
  late TextEditingController commandController;

  @override
  void initState() {
    autoEat = appConfig.autoEat;
    autoThrow = appConfig.autoThrow;
    autoReconnect = appConfig.autoReconnect;
    botAction = appConfig.botAction;
    autoDeposit = appConfig.autoDeposit;

    commandController = TextEditingController();

    super.initState();

    afterInit();
    analytics.pageView('Bot Status Page');
  }

  void afterInit() {
    if (botAction == BotActionType.attack) {
      widget.bot.attack(BotActionMethod.start);
    }

    widget.bot.whenEvent<DisconnectedEvent>((event) async {
      _logger.info('The bot has disconnected: ${event.reason}');

      Navigator.pop(context);
      if (appConfig.autoReconnect) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => ConnectingServer(
                account: widget.bot.account,
                reconnect: true,
                reconnectTimes: widget.bot.reconnectTimes + 1));
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('錯誤'),
                  content: Text(
                      '已與伺服器斷線，由於未啟用重新自動連線功能，因此將不會自動重新連線。\n斷線原因：${event.reason}'),
                  actions: const [ConfirmButton()],
                ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            widget.bot.disconnect();
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
            StreamBuilder(
                stream: widget.bot.whenEventStream<DisconnectedEvent>(),
                builder: (context, snapshot) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('連線狀態：${widget.bot.connected ? '已連線' : '未連線'}'),
                        Icon(
                            widget.bot.connected
                                ? Icons.check_circle
                                : Icons.error,
                            color: widget.bot.connected
                                ? Colors.green
                                : Colors.red)
                      ]);
                }),
            const SizedBox(height: 8),
            _Status(bot: widget.bot),
            const Divider(),
            Column(
              children: [
                const Text('機器人動作',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center),
                SizedBox(
                  width: 180,
                  child: Tooltip(
                    message: botAction.getTooltip(),
                    child: DropdownButton<BotActionType>(
                      value: botAction,
                      style: const TextStyle(color: Colors.lightBlue),
                      onChanged: (BotActionType? value) {
                        if (botAction != value) {
                          if (botAction == BotActionType.attack) {
                            widget.bot.attack(BotActionMethod.stop);
                          } else if (value == BotActionType.attack) {
                            widget.bot.attack(BotActionMethod.start);
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
                          width: 170,
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
                                  widget.bot.updateConfig();
                                },
                                title: const Text('自動飲食')),
                          ),
                        ),
                        SizedBox(
                          width: 205,
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
                                  widget.bot.updateConfig();
                                },
                                title: const Text('自動丟棄物品')),
                          ),
                        ),
                        SizedBox(
                          width: 205,
                          height: 50,
                          child: Tooltip(
                            message:
                                '自動重新連線伺服器，如果突然斷線或者廢土伺服器當機，會每 15 秒自動重新連線一次，若失敗超過 10 次則自動暫停。',
                            child: SwitchListTile(
                                value: autoReconnect,
                                onChanged: (value) {
                                  setState(() {
                                    autoReconnect = value;
                                  });
                                  appConfig.autoReconnect = autoReconnect;
                                  widget.bot.updateConfig();
                                },
                                title: const Text('自動重新連線')),
                          ),
                        ),
                        SizedBox(
                          width: 205,
                          height: 50,
                          child: Tooltip(
                            message:
                                '自動使用/bank存入綠寶石',
                            child: SwitchListTile(
                                value: autoDeposit,
                                onChanged: (value) {
                                  setState(() {
                                    autoDeposit = value;
                                  });
                                  appConfig.autoDeposit = autoDeposit;
                                  widget.bot.updateConfig();
                                },
                                title: const Text('自動存入')),
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
                      if (commandController.text == ".leave" || commandController.text == ".quit"){
                        widget.bot.disconnect();
                        Navigator.pop(context);
                      }
                      else {widget.bot.runCommand(commandController.text);}
                      commandController.text = '';
                    },
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                    onPressed: () {
                      if (commandController.text == ".leave" || commandController.text == ".quit"){
                        widget.bot.disconnect();
                        Navigator.pop(context);
                      }
                      else {widget.bot.runCommand(commandController.text);}
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

class _Status extends StatefulWidget {
  const _Status({
    Key? key,
    required this.bot,
  }) : super(key: key);

  final BotCore bot;

  @override
  State<_Status> createState() => _StatusState();
}

class _StatusState extends State<_Status> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StatusEvent>(
      stream: widget.bot.whenEventStream<StatusEvent>(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          final data = snapshot.data!;

          return Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.bot.account.getImage(width: 65, height: 65),
                    const SizedBox(width: 12),
                    Text(widget.bot.account.username),
                    const SizedBox(width: 12),
                    const VerticalDivider(),
                    const SizedBox(width: 12),
                    SelectableText.rich(TextSpan(children: [
                      TextSpan(text: '連線位置：${widget.bot.connectedData.host}\n'),
                      TextSpan(text: '通訊埠：${widget.bot.connectedData.port}\n'),
                      TextSpan(text: 'UUID：${widget.bot.account.uuid}\n'),
                      TextSpan(
                          text:
                              'Minecraft 遊戲版本：${widget.bot.connectedData.gameVersion}\n'),
                      TextSpan(
                          text:
                              '已連線時間：${Util.formatDuration(DateTime.now().difference(widget.bot.connectedData.startAt))}')
                    ])),
                  ],
                ),
              ),
              const Divider(),
              IntrinsicHeight(
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
                        Tooltip(
                          message: '共計 ${data.experience.points} 點經驗值',
                          child: SizedBox(
                              height: 50,
                              width: 300,
                              child: ExperienceIndicator(
                                  experience: data.experience)),
                        ),
                        Text('遊戲內時間：${Util.formatDuration(data.time)}'),
                      ],
                    ),
                    const SizedBox(width: 12),
                    const VerticalDivider(),
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        const Tooltip(
                            message: '機器人的物品欄內容 (未按照實際位置編排)',
                            child: Text('物品欄', style: TextStyle(fontSize: 20))),
                        const SizedBox(height: 8),
                        InventoryView(items: data.inventoryItems)
                      ],
                    )
                  ],
                ),
              ),
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
    );
  }
}
