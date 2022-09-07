import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

abstract class IEvent {}

abstract class IRawEvent {
  EventType get event;
  Map<String, dynamic> get data;
}

class RawEvent implements IRawEvent, IEvent {
  @override
  final EventType event;
  @override
  final Map<String, dynamic> data;

  const RawEvent(
    this.event,
    this.data,
  );

  factory RawEvent.create({
    required EventType type,
    required Map<String, dynamic> data,
  }) {
    return RawEvent(type, data);
  }

  RawEvent copyWith({
    EventType? event,
    Map<String, dynamic>? data,
  }) {
    return RawEvent(
      event ?? this.event,
      data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'event': event.name,
      'data': data,
    };
  }

  factory RawEvent.fromMap(Map<String, dynamic> map) {
    return RawEvent(
      EventType.values.byName(map['event']),
      Map<String, dynamic>.from(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory RawEvent.fromJson(String source) =>
      RawEvent.fromMap(json.decode(source));

  @override
  String toString() => 'BotEvent(event: $event, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final mapEquals = const DeepCollectionEquality().equals;

    return other is RawEvent &&
        other.event == event &&
        mapEquals(other.data, data);
  }

  @override
  int get hashCode => event.hashCode ^ data.hashCode;
}

enum EventType {
  info,
  warn,
  error,
  gameMessage,
  connected,
  disconnected,
  status
}
