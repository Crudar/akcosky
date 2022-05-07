part of 'info_cubit.dart';

@immutable
abstract class InfoState extends Equatable {
  const InfoState();
}

class InfoInitial extends InfoState {
  const InfoInitial();

  @override
  List<Object?> get props => [identityHashCode(this)];
}

class InfoEdit extends InfoState{
  const InfoEdit();

  @override
  List<Object?> get props => [identityHashCode(this)];
}
