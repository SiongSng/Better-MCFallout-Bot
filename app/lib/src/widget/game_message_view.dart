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

  @override
  void initState() {
    scrollController = ScrollController();

    super.initState();

    BotCore.instance!.whenEventStream<GameMessageEvent>().listen(messages.add);

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (messages.length > maxMessageLength) {
          // Delete old messages
          messages.removeRange(0, messages.length - maxMessageLength);
        }

        // Auto scroll to bottom
        if (scrollController.hasClients &&
            scrollController.position.pixels !=
                scrollController.position.maxScrollExtent) {
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
    return ListView.builder(
        controller: scrollController,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];

          return ListTile(
            title: SelectableText(message.message),
            subtitle: Text(message.sentAt.toString()),
          );
        });
  }
}
