part of 'participants_cubit.dart';

abstract class ParticipantsState {
  const ParticipantsState();
}

class ParticipantsInitial extends ParticipantsState {
  const ParticipantsInitial();
}

class ParticipantsShowMore extends ParticipantsState {
  const ParticipantsShowMore();
}

class ParticipantsRefresh extends ParticipantsState {
  const ParticipantsRefresh();
}
