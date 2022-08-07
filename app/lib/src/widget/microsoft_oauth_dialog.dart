import 'dart:async';
import 'dart:io';

import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:oauth2/oauth2.dart';

class MicrosoftOauthDialog extends StatefulWidget {
  const MicrosoftOauthDialog({Key? key}) : super(key: key);

  @override
  State<MicrosoftOauthDialog> createState() => _MSLoginState();
}

typedef AuthenticatedBuilder = Widget Function(
    BuildContext context, oauth2.Client client);

class _MSLoginState extends State<MicrosoftOauthDialog> {
  late final HttpServer _redirectServer;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Client>(
        future: bindServer(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            oauth2.Client client = snapshot.data!;

            return StreamBuilder<MicrosoftAccountStatus>(
                stream: MicrosoftOauthHandler.authorization(client.credentials),
                initialData: MicrosoftAccountStatus.xbl,
                builder: (context, snapshot) {
                  MicrosoftAccountStatus status = snapshot.data!;

                  if (status.isError) {
                    return AlertDialog(
                      title: const Text('錯誤'),
                      content: Text(status.stateMessage),
                      actions: const [ConfirmButton()],
                    );
                  } else if (status == MicrosoftAccountStatus.successful) {
                    return AlertDialog(
                      title: const Text('資訊'),
                      content: Text(status.stateMessage),
                      actions: [
                        ConfirmButton(onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AccountPage()));
                        })
                      ],
                    );
                  } else {
                    return AlertDialog(
                      title: const Text('處理狀態'),
                      content: Text(status.stateMessage),
                    );
                  }
                });
          } else if (snapshot.hasError) {
            return AlertDialog(
              title: const Text('錯誤'),
              content:
                  Text('處理登入資料時發生未知錯誤：${snapshot.error}\n請稍後再試，如仍然失敗請聯繫作者'),
              actions: const [ConfirmButton()],
            );
          } else {
            return AlertDialog(
                title: const Text('已開啟 Microsoft 登入網頁，請在瀏覽器中登入帳號...'),
                content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [CircularProgressIndicator()]));
          }
        });
  }

  Future<Client> bindServer() async {
    _redirectServer = await HttpServer.bind('127.0.0.1', 16832);
    return await _getOAuth2Client(
        Uri.parse('http://127.0.0.1:16832/microsoft-oauth2-callback'));
  }

  Future<oauth2.Client> _getOAuth2Client(Uri redirectUrl) async {
    final authorizationEndpoint =
        Uri.parse('https://login.live.com/oauth20_authorize.srf');
    final tokenEndpoint = Uri.parse('https://login.live.com/oauth20_token.srf');

    final grant = oauth2.AuthorizationCodeGrant(
      // Azure Application Client ID
      MicrosoftOauthHandler.clientID,
      authorizationEndpoint,
      tokenEndpoint,
    );
    Uri authorizationUrl = grant.getAuthorizationUrl(redirectUrl,
        scopes: ['XboxLive.signin', 'offline_access']);
    await Util.openUri(
        '${authorizationUrl.toString()}&cobrandid=8058f65d-ce06-4c30-9559-473c9275a65d&prompt=select_account');
    final responseQueryParameters = await _listenParameters();

    return await grant.handleAuthorizationResponse(responseQueryParameters);
  }

  Future<Map<String, String>> _listenParameters() async {
    final request = await _redirectServer.first;
    final params = request.uri.queryParameters;
    request.response.statusCode = 200;
    request.response.headers.set('content-type', 'text/plain; charset=utf-8');
    request.response.writeln('驗證完畢，請回到 Better MCFallout Bot 內。');
    await request.response.close();
    await _redirectServer.close();

    return params;
  }
}
