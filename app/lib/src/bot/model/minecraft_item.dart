class MinecraftItem {
  final String name;
  final String displayName;
  final int count;
  final int type;

  const MinecraftItem({
    required this.name,
    required this.displayName,
    required this.count,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'displayName': displayName,
      'count': count,
      'type': type,
    };
  }

  factory MinecraftItem.fromMap(Map<String, dynamic> map) {
    return MinecraftItem(
      name: map['name'],
      displayName: map['displayName'],
      count: map['count'],
      type: map['type'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MinecraftItem &&
        other.name == name &&
        other.displayName == displayName &&
        other.count == count &&
        other.type == type;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        displayName.hashCode ^
        count.hashCode ^
        type.hashCode;
  }
}
