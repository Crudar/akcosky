import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'participants_state.dart';

class ParticipantsCubit extends Cubit<ParticipantsState> {
  ParticipantsCubit() : super(ParticipantsInitial());

  bool showMore = true;

  void showMoreLess(){
    if(showMore) {
      showMore = !showMore;

      emit(ParticipantsShowMore());
    }
    else{
      showMore = !showMore;

      emit(ParticipantsInitial());
    }

  }
}
