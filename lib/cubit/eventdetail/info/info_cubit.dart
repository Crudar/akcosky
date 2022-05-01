import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'info_state.dart';

class InfoCubit extends Cubit<InfoState> {
  InfoCubit() : super(InfoInitial());

  showEditField(){
    emit(InfoEdit());
  }

  showInitialField(){
    emit(InfoInitial());
  }
}

