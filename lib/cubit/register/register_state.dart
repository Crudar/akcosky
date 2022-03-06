part of 'register_cubit.dart';

@immutable
abstract class RegisterState {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState{
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState{
  const RegisterSuccess();
}

class RegisterAuthenticate extends RegisterState{
  const RegisterAuthenticate();
}

class AuthenticateError extends RegisterState{
  const AuthenticateError();
}

class RegisterError extends RegisterState{
  final String message;
  const RegisterError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegisterError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}