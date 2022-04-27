import 'package:akcosky/models/VoteEnum.dart';
import 'package:akcosky/resources/EventRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuple/tuple.dart';

import '../../../models/Vote.dart';

part 'voting_state.dart';

class VotingCubit extends Cubit<VotingState> {
  final EventRepository _eventRepository;

  VotingCubit(this._eventRepository) : super(VotingInitial());

  voting(Vote vote) async {
    // TODO - save to DB + save to event and reload or reload whole event load

    Tuple2<bool, String> response = await _eventRepository.updateUserVote(vote);

    if (response.item1) {
      emit(VotingSuccessfullVote(vote));
    }
    else if (response.item1 == false && response.item2 == "Socket") {
      emit(VotingError("Nemožno zmeniť hlas. Si pripojený na internet?"));
    }
    else if(response.item1 == false && response.item2 == "NotExist"){
      emit(VotingStatusMessage("Zadaný hlas neexistuje"));
    }
  }

  changeVote(){
    emit(VotingUnvoted());
  }
}
