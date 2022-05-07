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