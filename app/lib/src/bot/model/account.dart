import 'dart:convert';

import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart' hide NetworkImage;
import 'package:oauth2/oauth2.dart';

class Account {
  final String uuid;
  final String username;
  final String minecraftToken;
  final Credentials credentials;

  const Account({
    required this.uuid,
    required this.username,
    required this.minecraftToken,
    required this.credentials,
  });

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'username': username,
      'minecraftToken': minecraftToken,
      'credentials': credentials.toJson(),
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      uuid: map['uuid'],
      username: map['username'],
      minecraftToken: map['minecraftToken'],
      credentials: Credentials.fromJson(map['credentials']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source));

  Widget getImage({double? width, double? height}) => NetworkImage(
        src: 'https://crafatar.com/avatars/$uuid?overlay',
        width: width,
        height: height,
        errorWidget: Icon(
          Icons.person,
          size: width ?? height,
        ),
      );
}
