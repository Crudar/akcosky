part of 'registerstart_cubit.dart';

@immutable
abstract class RegisterStartState {
  const RegisterStartState();
}

class RegisterStartInitial extends RegisterStartState {
  const RegisterStartInitial();
}

class RegisterStartLoading extends RegisterStartState{
  const RegisterStartLoading();
}

class RegisterStartAuthenticate extends RegisterStartState{
  const RegisterStartAuthenticate();
}

class RegisterStartError extends RegisterStartState{
  final String message;
  const RegisterStartError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegisterStartError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}