part of 'info_cubit.dart';

@immutable
abstract class InfoState {
  const InfoState();
}

class InfoInitial extends InfoState {
  const InfoInitial();
}

class InfoEdit extends InfoState{
  const InfoEdit();
}
