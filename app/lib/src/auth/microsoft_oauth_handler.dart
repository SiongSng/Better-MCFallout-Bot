import 'dart:async';
import 'dart:convert';
import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:oauth2/oauth2.dart';
import 'package:uuid/uuid.dart';

Map<String, String> _baseHeaders = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
};
final Logger _logger = Logger('microsoft_oauth_handler');

enum MicrosoftAccountStatus {
  unknown,
  xbl,
  xsts,
  xstsError,
  isChild,
  bannedCountry,
  noneXboxAccount,
  minecraftAuthorize,
  minecraftAuthorizeError,
  checkingGameOwnership,
  notGameOwnership,
  profileNotFoundXbox,
  successful;

  String get stateMessage {
    switch (this) {
      case MicrosoftAccountStatus.xbl:
        return '正在取得 Xbox Live 憑證中...';
      case MicrosoftAccountStatus.xsts:
        return '正在取得 XSTS 憑證...';
      case MicrosoftAccountStatus.xstsError:
        return '無法取得 XSTS 憑證';
      case MicrosoftAccountStatus.isChild:
        return '此 Microsoft 帳號為未成年帳號，因此無法透過第三方登入';
      case MicrosoftAccountStatus.bannedCountry:
        return 'Xbox Live 在您所在的國家/地區無法使用';
      case MicrosoftAccountStatus.noneXboxAccount:
        return '此 Microsoft 帳號沒有 Xbox Live 資料';
      case MicrosoftAccountStatus.minecraftAuthorize:
        return '正在登入 Minecraft 帳號中...';
      case MicrosoftAccountStatus.minecraftAuthorizeError:
        return '無法登入 Minecraft 帳號';
      case MicrosoftAccountStatus.checkingGameOwnership:
        return '正在檢查該帳號是否擁有 Minecraft...';
      case MicrosoftAccountStatus.notGameOwnership:
        return '此帳號尚未購買 Minecraft';
      case MicrosoftAccountStatus.profileNotFoundXbox:
        return '由於您的帳號是透過 Xbox Game Pass 購買的，請先到 Minecraft 官方啟動器內完成帳號註冊後再到此登入';
      case MicrosoftAccountStatus.successful:
        return '帳號新增成功';
      case MicrosoftAccountStatus.unknown:
        return '登入 Microsoft 帳號時發生未知錯誤';
    }
  }

  bool get isError {
    switch (this) {
      case MicrosoftAccountStatus.xstsError:
        return true;
      case MicrosoftAccountStatus.isChild:
        return true;
      case MicrosoftAccountStatus.bannedCountry:
        return true;
      case MicrosoftAccountStatus.noneXboxAccount:
        return true;
      case MicrosoftAccountStatus.minecraftAuthorizeError:
        return true;
      case MicrosoftAccountStatus.notGameOwnership:
        return true;
      case MicrosoftAccountStatus.profileNotFoundXbox:
        return true;
      case MicrosoftAccountStatus.unknown:
        return true;
      default:
        return false;
    }
  }
}

class MicrosoftOauthHandler {
  /*
  API Docs: https://wiki.vg/Microsoft_Authentication_Scheme
  M$ Oauth2: https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-auth-code-flow
  M$ Register Application: https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app
   */

  static Stream<MicrosoftAccountStatus> authorization(
      Credentials credentials) async* {
    try {
      yield MicrosoftAccountStatus.xbl;
      final Map xboxLiveData = await _authorizationXBL(credentials.accessToken);
      final String xblToken = xboxLiveData['Token'];
      final String userHash = xboxLiveData['DisplayClaims']['xui'][0]['uhs'];

      yield MicrosoftAccountStatus.xsts;
      final Response response = await _authorizationXSTS(xblToken, userHash);

      Map? xstsData;

      if (response.statusCode == 200) {
        xstsData = json.decode(response.body);
      } else if (response.statusCode == 401) {
        final Map data = json.decode(response.body);
        final int xError = data['XErr'];
        if (xError == 2148916233) {
          //此微軟帳號沒有Xobx帳號
          yield MicrosoftAccountStatus.noneXboxAccount;
        } else if (xError == 2148916235) {
          /// Xbox在該國家/地區無法使用
          yield MicrosoftAccountStatus.bannedCountry;
        } else if (xError == 2148916238) {
          ///是未成年的帳號 (18歲以下)
          yield MicrosoftAccountStatus.isChild;
        }
        return;
      }

      if (xstsData == null) {
        _logger.severe('Failed to get XSTS data: ${response.body}',
            '${response.reasonPhrase} (${response.statusCode})');
        yield MicrosoftAccountStatus.xstsError;
        return;
      }

      final String xstsToken = xstsData['Token'];
      final String xstsUserHash = xstsData['DisplayClaims']['xui'][0]['uhs'];

      yield MicrosoftAccountStatus.minecraftAuthorize;
      final Map? minecraftAuthorizeData =
          await _authorizationMinecraft(xstsToken, xstsUserHash);

      if (minecraftAuthorizeData == null) {
        MicrosoftAccountStatus.minecraftAuthorizeError;
        return;
      }

      final String minecraftToken = minecraftAuthorizeData['access_token'];

      yield MicrosoftAccountStatus.checkingGameOwnership;
      final bool canPlayMinecraft =
          await _checkingGameOwnership(minecraftToken);

      if (canPlayMinecraft) {
        final Map? profile = await getProfile(minecraftToken);

        if (profile != null) {
          await accountStorage.add(Account(
              uuid: profile['id'],
              username: profile['name'],
              minecraftToken: minecraftToken,
              credentials: credentials));
          yield MicrosoftAccountStatus.successful;
        } else {
          yield MicrosoftAccountStatus.profileNotFoundXbox;
        }
      } else {
        yield MicrosoftAccountStatus.notGameOwnership;
      }
    } catch (e, stackTrace) {
      _logger.severe('Failed to authenticate microsoft account', e, stackTrace);
      yield MicrosoftAccountStatus.unknown;
    }
    return;
  }

  /// Verify the microsoft account is able to play minecraft
  static Future<bool> validate(String accessToken) async {
    final Response response = await get(
        Uri.parse('https://api.minecraftservices.com/minecraft/profile'),
        headers: _baseHeaders
          ..addAll({'Authorization': 'Bearer $accessToken'}));

    return response.statusCode == 200;
  }

  /// Authenticate with Xbox Live
  static Future<Map> _authorizationXBL(String accessToken) async {
    final Response response = await post(
        Uri.parse('https://user.auth.xboxlive.com/user/authenticate'),
        body: json.encode({
          'Properties': {
            'AuthMethod': 'RPS',
            'SiteName': 'user.auth.xboxlive.com',
            'RpsTicket': 'd=$accessToken'
          },
          'RelyingParty': 'http://auth.xboxlive.com',
          'TokenType': 'JWT'
        }),
        headers: _baseHeaders);

    return json.decode(response.body);
  }

  /// Authenticate with XSTS
  static Future<Response> _authorizationXSTS(
      String xblToken, String userHash) async {
    final Response response =
        await post(Uri.parse('https://xsts.auth.xboxlive.com/xsts/authorize'),
            body: json.encode({
              'Properties': {
                'SandboxId': 'RETAIL',
                'UserTokens': [xblToken]
              },
              'RelyingParty': 'rp://api.minecraftservices.com/',
              'TokenType': 'JWT'
            }),
            headers: _baseHeaders);

    return response;
  }

  /// Authenticate with Minecraft
  static Future<Map?> _authorizationMinecraft(
      String xstsToken, String userHash) async {
    final Response response = await post(
        Uri.parse('https://api.minecraftservices.com/launcher/login'),
        body: json.encode({
          'xtoken': 'XBL3.0 x=$userHash;$xstsToken',
          'platform': 'PC_LAUNCHER'
        }),
        headers: _baseHeaders);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      _logger.severe(
          'Failed to authenticate minecraft account: ${response.body}',
          '${response.reasonPhrase} (${response.statusCode})');
      return null;
    }
  }

  /// Checking Game Ownership
  static Future<bool> _checkingGameOwnership(String accessToken) async {
    final Response response = await get(
        Uri.parse('https://api.minecraftservices.com/entitlements/license')
            .replace(queryParameters: {
          // Generate a random uuid
          'requestId': const Uuid().v4(),
        }),
        headers: _baseHeaders
          ..addAll({'Authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      final entitlements = MicrosoftEntitlements.fromJson(response.body);

      return entitlements.canPlayMinecraft;
    } else {
      return false;
    }
  }

  static Future<Map?> getProfile(mcAccessToken) async {
    final Response response = await get(
      Uri.parse('https://api.minecraftservices.com/minecraft/profile'),
      headers: _baseHeaders..addAll({'Authorization': 'Bearer $mcAccessToken'}),
    );

    final Map data = json.decode(response.body);

    if (data['error'].toString() == 'NOT_FOUND') {
      return null;
    } else {
      return data;
    }
  }
}
