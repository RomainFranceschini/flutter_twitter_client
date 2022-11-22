import 'dart:math' as math;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:twitter_oauth2_pkce/twitter_oauth2_pkce.dart';

class TokenRepository {
  static const tokenKey = 'accessToken';
  static const refreshTokenKey = 'refreshToken';
  static const scopesKey = 'accessTokenScopes';
  static const expirationDateKey = 'accessTokenExpirationDate';

  late final FlutterSecureStorage _storage;

  TokenRepository() {
    _storage = const FlutterSecureStorage();
  }

  Future<void> saveToken(OAuthResponse token) async {
    _storage.write(
        key: expirationDateKey, value: token.expireAt.toIso8601String());
    _storage.write(
        key: scopesKey,
        value: token.scopes.map((scope) => scope.value).join(' '));
    _storage.write(key: tokenKey, value: token.accessToken);
    _storage.write(key: refreshTokenKey, value: token.refreshToken);
  }

  Future<OAuthResponse?> getToken() async {
    final expirationDate = await _storage.read(key: expirationDateKey);

    if (expirationDate != null) {
      final accessToken = await _storage.read(key: tokenKey);
      final refreshToken = await _storage.read(key: refreshTokenKey);
      final scopes = await _storage.read(key: scopesKey);

      return OAuthResponse.fromJson({
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'scope': scopes,
        'expires_in': math.max(
            0,
            DateTime.parse(expirationDate)
                .difference(DateTime.now())
                .inSeconds),
      });
    }
  }
}
