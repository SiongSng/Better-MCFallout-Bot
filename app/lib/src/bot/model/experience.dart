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
    return Experience(
      level: map['level'] as int,
      points: map['points'] as int,
      progress: map['progress'] as double,
    );
  }
}
