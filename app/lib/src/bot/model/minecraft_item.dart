class MinecraftItem {
  final String name;
  final String displayName;
  final int stackSize;
  final int type;

  const MinecraftItem({
    required this.name,
    required this.displayName,
    required this.stackSize,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'displayName': displayName,
      'stackSize': stackSize,
      'type': type,
    };
  }

  factory MinecraftItem.fromMap(Map<String, dynamic> map) {
    return MinecraftItem(
      name: map['name'],
      displayName: map['displayName'],
      stackSize: map['stackSize'],
      type: map['type'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MinecraftItem &&
        other.name == name &&
        other.displayName == displayName &&
        other.stackSize == stackSize &&
        other.type == type;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        displayName.hashCode ^
        stackSize.hashCode ^
        type.hashCode;
  }
}
