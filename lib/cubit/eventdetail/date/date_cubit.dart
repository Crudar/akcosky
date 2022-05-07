import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'date_state.dart';

class DateCubit extends Cubit<DateState> {
  DateCubit() : super(DateInitial());

  bool moreDayAction = false;

  updateMoreDayCheckbox(){
    moreDayAction = !moreDayAction;

    emit(DateEdit());
  }

  showEditField(){
    emit(DateEdit());
  }

  showInitialField(){
    emit(DateInitial());
  }
}
