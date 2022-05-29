part of 'registerstart_cubit.dart';

@immutable
abstract class RegisterStartState extends Equatable {
  const RegisterStartState();
}

class RegisterStartInitial extends RegisterStartState {
  const RegisterStartInitial();

  @override
  List<Object> get props => [identityHashCode(this)];
}

class RegisterStartLoading extends RegisterStartState{
  const RegisterStartLoading();

  @override
  List<Object> get props => [identityHashCode(this)];
}

class RegisterStartAuthenticate extends RegisterStartState{
  const RegisterStartAuthenticate();

  @override
  List<Object> get props => [identityHashCode(this)];
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

  @override
  List<Object> get props => [identityHashCode(this)];
}