part of 'registerfinal_cubit.dart';

@immutable
abstract class RegisterFinalState {
  const RegisterFinalState();
}

class RegisterFinalLoading extends RegisterFinalState {
  const RegisterFinalLoading();
}

class RegisterFinalInitial extends RegisterFinalState {
  const RegisterFinalInitial();
}

class RegisterFinalSuccess extends RegisterFinalState{
  const RegisterFinalSuccess();
}

class RegisterFinalError extends RegisterFinalState{
  final String message;
  const RegisterFinalError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RegisterFinalError &&
              runtimeType == other.runtimeType &&
              message == other.message;

  @override
  int get hashCode => message.hashCode;
}
