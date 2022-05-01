import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'date_state.dart';

class DateCubit extends Cubit<DateState> {
  DateCubit() : super(DateInitial());

  late DateTime? newDateTime;
  late DateTimeRange? newDateTimeRange;

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

  showEditField(){
    emit(DateEdit());
  }

  showInitialField(){
    emit(DateInitial());
  }
}
