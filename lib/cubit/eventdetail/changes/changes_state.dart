part of 'changes_cubit.dart';

@immutable
abstract class ChangesState extends Equatable {
  const ChangesState();
}

class ChangesInitial extends ChangesState {
  const ChangesInitial();

  @override
  List<Object> get props => [identityHashCode(this)];
}

class ChangesSave extends ChangesState{
  const ChangesSave();

  @override
  List<Object> get props => [identityHashCode(this)];
}

class ChangesSuccessfull extends ChangesState{
  const ChangesSuccessfull();

  @override
  List<Object> get props => [identityHashCode(this)];
}

class ChangesStatusMessage extends ChangesState{
  final String message;
  const ChangesStatusMessage(this.message);

  @override
  List<Object> get props => [message];
}