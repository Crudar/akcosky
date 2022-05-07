import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'changes_state.dart';

class ChangesCubit extends Cubit<ChangesState> {
  ChangesCubit() : super(ChangesInitial());

  late DateTime? newDateTime;
  late DateTimeRange? newDateTimeRange;

  bool moreDayAction = false;

  bool saveButtonVisible = false;

  saveChangesButtonLoad(){
    if(saveButtonVisible == false){
      saveButtonVisible = true;

      emit(ChangesSave());
    }
  }

  saveChanges(){

  }

  updateDate(DateTime? dateTime){
    newDateTime = dateTime;
  }

  updateTime(TimeOfDay? time){
    int hour = time?.hour ?? 0;
    int minute = time?.minute ?? 0;

    newDateTime = newDateTime?.add(Duration(hours: hour, minutes: minute));
  }

  updateDateRange(DateTimeRange? dateTimeRange){
    newDateTimeRange = dateTimeRange;
  }
}
