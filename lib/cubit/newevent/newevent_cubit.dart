import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'newevent_state.dart';

class NewEventCubit extends Cubit<NewEventState> {
  int stepperState = 0;
  int selectedActivityTypeIndex = 0;
  String selectedActivityTypeIcon = "";

  NewEventCubit() : super(NewEventInitial());

  updateStepperState(int state){
    stepperState = state;

    emit(NewEventInitial());
  }

  updateSelectedActivityType(int index, path){
    selectedActivityTypeIndex = index;
    selectedActivityTypeIcon = path;

    emit(NewEventInitial());
  }
}
