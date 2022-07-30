import 'package:flutter/material.dart';

class HungerIndicator extends StatefulWidget {
  final double hunger;
  const HungerIndicator({Key? key, required this.hunger}) : super(key: key);

  @override
  State<HungerIndicator> createState() => _HungerIndicatorState();
}

class _HungerIndicatorState extends State<HungerIndicator> {
  final List<Widget> children = [];

  @override
  void initState() {
    final int fullHunger = widget.hunger ~/ 2;
    final int emptyHunger = 10 - fullHunger;

    for (int i = 0; i < fullHunger; i++) {
      children.add(const Icon(Icons.cake, color: Colors.white));
    }
    for (int i = 0; i < emptyHunger; i++) {
      children.add(const Icon(Icons.cake_outlined, color: Colors.white));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [const Text('飢餓值：'), ...children]);
  }
}
