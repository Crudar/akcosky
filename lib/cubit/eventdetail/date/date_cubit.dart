import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'date_state.dart';

class DateCubit extends Cubit<DateState> {
  DateCubit() : super(DateInitial());

  DateTime? newDateTime;
  DateTimeRange? newDateTimeRange;

  bool moreDayAction = false;

  String dateText = "Vyber dátum a čas akcie";

  updateMoreDayCheckbox(){
    moreDayAction = !moreDayAction;

    emit(DateEdit());
  }

  updateDate(DateTime? dateTime){
    var formatter = DateFormat('dd.MM.yyyy');

    if(dateTime != null){
      dateText = formatter.format(dateTime);
    }
    else{
      dateText = "Vyber dátum a čas akcie";
    }

    newDateTime = dateTime?.toLocal();
  }

  updateTime(TimeOfDay? time){
    int hour = time?.hour ?? 0;
    int minute = time?.minute ?? 0;

    newDateTime = newDateTime?.add(Duration(hours: hour, minutes: minute));

    var formatterDate = DateFormat('dd.MM.yyyy');
    var formatterTime = DateFormat.Hm();

    if(newDateTime != null){
      dateText = formatterDate.format(newDateTime!) + " " + formatterTime.format(newDateTime!);
    }
    else{
      dateText = "Vyber dátum a čas akcie";
    }
  }

  updateDateRange(DateTimeRange? dateTimeRange){
    var formatter = DateFormat('dd.MM.yyyy');

    if(dateTimeRange != null){
      String dateStart = formatter.format(dateTimeRange.start);
      String dateEnd = formatter.format(dateTimeRange.end);

      dateText = dateStart + " - " + dateEnd;
    }
    else{
      dateText = "Vyber dátum a čas akcie";
    }

    newDateTimeRange = dateTimeRange;
  }

  showEditField(){
    emit(DateEdit());
  }

  showInitialField(){
    emit(DateInitial());
  }
}
