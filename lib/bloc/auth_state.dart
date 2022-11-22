part of 'auth_cubit.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class SignedInState extends AuthState {
  final OAuthResponse token;

  const SignedInState(this.token);
}

class SignedOutState extends AuthState {
  const SignedOutState();
}

class SignInError extends AuthState {
  final Object? error;

  const SignInError(this.error);
}

class SigningIn extends AuthState {
  const SigningIn();
}
