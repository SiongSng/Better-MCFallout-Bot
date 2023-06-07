import 'dart:async';

import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart';

class GameMessageView extends StatefulWidget {
  const GameMessageView({Key? key}) : super(key: key);

  @override
  State<GameMessageView> createState() => _GameMessageViewState();
}

class _GameMessageViewState extends State<GameMessageView> {
  final int maxMessageLength = 100;
  final List<GameMessageEvent> messages = [];

  late final ScrollController scrollController;

  bool autoScroll = true;

  @override
  void initState() {
    scrollController = ScrollController();

    super.initState();

    BotCore.instance!.whenEventStream<GameMessageEvent>().listen((event) {
      messages.add(event);
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (messages.length > maxMessageLength) {
          // Delete old messages
          messages.removeRange(0, messages.length - maxMessageLength);
        }

        // Auto scroll to bottom
        if (scrollController.hasClients &&
            scrollController.position.pixels !=
                scrollController.position.maxScrollExtent &&
            autoScroll) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 50,
            width: 250,
            child: SwitchListTile(
                value: autoScroll,
                onChanged: (value) => setState(() => autoScroll = value),
                title: const Text('自動滾動訊息至底部'))),
        Expanded(
          child: SelectionArea(
            child: ListView.builder(
                controller: scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
          
                  return ListTile(
                    title: Text(message.message,
                        textAlign: TextAlign.center),
                    subtitle: Text(message.sentAt.toString(),
                        textAlign: TextAlign.center),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
