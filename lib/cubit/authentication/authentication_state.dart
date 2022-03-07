part of 'authentication_cubit.dart';

@immutable
abstract class AuthenticationState {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial();
}

class AuthenticationAuthenticated extends AuthenticationState {
  const AuthenticationAuthenticated();
}

class AuthenticationUnAuthenticated extends AuthenticationState {
  const AuthenticationUnAuthenticated();
}
