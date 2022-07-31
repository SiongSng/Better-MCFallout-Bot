import 'dart:io';

import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Builder(builder: (context) {
          Image defaultImage = Image.asset(
            'assets/images/background.png',
            fit: BoxFit.fill,
          );

          if (appConfig.backgroundPath != null) {
            final file = File(appConfig.backgroundPath!);
            if (file.existsSync()) {
              defaultImage = Image.file(file, fit: BoxFit.fill);
            } else {
              return defaultImage;
            }
          }

          return defaultImage;
        }),
      ),
      Opacity(
        opacity: 0.18,
        child: ColoredBox(
          color: Colors.black,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
      child
    ]);
  }
}
