class Experience {
  final int level;
  final int points;
  final double progress;

  const Experience({
    required this.level,
    required this.points,
    required this.progress,
  });

  factory Experience.fromMap(Map<String, dynamic> map) {
    double progress;
    dynamic progressValue = map['progress'];

    if (progressValue is int) {
      progress = progressValue.toDouble();
    } else {
      progress = progressValue as double;
    }

    return Experience(
        level: map['level'] as int,
        points: map['points'] as int,
        progress: progress);
  }
}
