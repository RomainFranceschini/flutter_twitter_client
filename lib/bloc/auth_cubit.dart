import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:twitter_client/repositories/token_repository.dart';
import 'package:twitter_oauth2_pkce/twitter_oauth2_pkce.dart';

import '../config.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final TokenRepository _tokenRepository;

  AuthCubit(this._tokenRepository) : super(AuthInitial());

  Future<void> restoreTokenFromCache() async {
    try {
      final token = await _tokenRepository.getToken();
      if (token != null && token.isNotExpired) {
        emit(SignedInState(token));
      } else {
        emit(const SignedOutState());
      }
    } catch (e) {
      emit(const SignedOutState());
    }
  }

  Future<void> signInWithTwitter() async {
    emit(const SigningIn());
    try {
      final oauth2 = TwitterOAuth2Client(
        clientId: 'aWgxREMzZjFHWDJLV3lNTXdPTHo6MTpjaQ',
        clientSecret: twitterApiSecret,
        redirectUri: 'org.example.android.oauth://callback/',
        customUriScheme: 'org.example.android.oauth',
      );

      final response = await oauth2.executeAuthCodeFlowWithPKCE(
        scopes: Scope.values,
      );

      await _tokenRepository.saveToken(response);

      emit(SignedInState(response));
    } catch (e) {
      emit(SignInError(e));
    }
  }
}
