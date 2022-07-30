import 'package:flutter/material.dart';

class HealthIndicator extends StatefulWidget {
  final int health;
  const HealthIndicator({Key? key, required this.health}) : super(key: key);

  @override
  State<HealthIndicator> createState() => _HealthIndicatorState();
}

class _HealthIndicatorState extends State<HealthIndicator> {
  final List<Widget> children = [];

  @override
  void initState() {
    final int fullHealth = widget.health ~/ 2;
    final int emptyHealth = 10 - fullHealth;

    for (int i = 0; i < fullHealth; i++) {
      children.add(const Icon(Icons.favorite, color: Colors.red));
    }
    for (int i = 0; i < emptyHealth; i++) {
      children.add(const Icon(Icons.favorite_border, color: Colors.white));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [const Text('生命值：'), ...children]);
  }
}
