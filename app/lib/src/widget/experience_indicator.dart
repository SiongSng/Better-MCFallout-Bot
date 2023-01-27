import 'package:better_mcfallout_bot/src/bot/model/experience.dart';
import 'package:flutter/material.dart';

class ExperienceIndicator extends StatelessWidget {
  final Experience experience;
  const ExperienceIndicator({super.key, required this.experience});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('經驗值：'),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${experience.level} 等'),
              LinearProgressIndicator(
                value: experience.progress,
                backgroundColor: const Color(0XFF29352F),
                valueColor: const AlwaysStoppedAnimation(Color(0XFF84B45D)),
                minHeight: 8,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
