part of 'newevent_cubit.dart';

@immutable
abstract class NewEventState {
  const NewEventState();
}

class NewEventInitial extends NewEventState {
  const NewEventInitial();
}

class NewEventFinish extends NewEventState{
  const NewEventFinish();
}

class NewEventError extends NewEventState{
  final String message;
  const NewEventError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewEventError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
