import 'dart:convert';

class MicrosoftEntitlements {
  final List<EntitlementItem> items;
  final String signature;
  final String keyId;
  final String requestId;

  bool get canPlayMinecraft =>
      items.any((item) => item.name == 'product_minecraft') &&
      items.any((item) => item.name == 'game_minecraft');

  const MicrosoftEntitlements({
    required this.items,
    required this.signature,
    required this.keyId,
    required this.requestId,
  });

  factory MicrosoftEntitlements.fromMap(Map<String, dynamic> map) {
    return MicrosoftEntitlements(
      items: List<EntitlementItem>.from(
          map['items']?.map((x) => EntitlementItem.fromMap(x))),
      signature: map['signature'],
      keyId: map['keyId'],
      requestId: map['requestId'],
    );
  }

  factory MicrosoftEntitlements.fromJson(String source) =>
      MicrosoftEntitlements.fromMap(json.decode(source));
}

class EntitlementItem {
  final String name;
  final String source;
  EntitlementItem({
    required this.name,
    required this.source,
  });

  EntitlementItem copyWith({
    String? name,
    String? source,
  }) {
    return EntitlementItem(
      name: name ?? this.name,
      source: source ?? this.source,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'source': source,
    };
  }

  factory EntitlementItem.fromMap(Map<String, dynamic> map) {
    return EntitlementItem(
      name: map['name'],
      source: map['source'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EntitlementItem.fromJson(String source) =>
      EntitlementItem.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EntitlementItem &&
        other.name == name &&
        other.source == source;
  }

  @override
  int get hashCode => name.hashCode ^ source.hashCode;
}
