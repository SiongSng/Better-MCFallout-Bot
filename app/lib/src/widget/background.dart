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
          // TODO: 提供使用者自訂背景或每日更換之類的

          Image defaultImage = Image.asset(
            "assets/images/background.png",
            fit: BoxFit.fill,
          );

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
