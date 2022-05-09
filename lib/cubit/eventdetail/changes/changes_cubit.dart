import 'package:akcosky/Helpers/GetColumnName.dart';
import 'package:akcosky/cubit/eventdetail/date/date_cubit.dart';
import 'package:akcosky/models/DateEnum.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:tuple/tuple.dart';

import '../../../models/Event_.dart';
import '../../../models/TypeEnum.dart';
import '../../../resources/EventRepository.dart';

part 'changes_state.dart';

class ChangesCubit extends Cubit<ChangesState> {
  final EventRepository eventRepository;

  ChangesCubit(this.eventRepository) : super(ChangesInitial());

  DateTime? newDateTime;
  DateTimeRange? newDateTimeRange;

  bool moreDayAction = false;

  saveChanges(Event_ selectedEvent, Map<TypeEnum, TextEditingController> controllers) async {
    controllers.remove(TypeEnum.dates);
    Map<String, String> valuesToUpdate = {};

    DateTimeRange? range = newDateTimeRange;
    DateTime? time = newDateTime;

    if(range != null){
      valuesToUpdate["DatumZaciatok"] = range.start.toIso8601String();
      valuesToUpdate["DatumKoniec"] = range.end.toIso8601String();
    }
    else{
      if(time != null) {
        valuesToUpdate["DatumZaciatok"] = time.toIso8601String();
      }
    }

    controllers.forEach((key, value) {
      if(value.text != "") {
        valuesToUpdate[getColumnName(key)] = value.text;
      }
    });

    Tuple2<bool, String> response = await eventRepository.updateEvent(selectedEvent.ID, valuesToUpdate);

    if (response.item1) {
      if(range != null){
        selectedEvent.info[TypeEnum.dates]?.value[DateEnum.startDate] = range.start;
        selectedEvent.info[TypeEnum.dates]?.value[DateEnum.endDate] = range.end;
      }
      else{
        if(time != null) {
          selectedEvent.info[TypeEnum.dates]?.value[DateEnum.startDate] = time;
        }
      }

      controllers.forEach((key, value) {
        if(value.text != "") {
          selectedEvent.info[key]?.value = value.text;
        }
      });

      emit(ChangesSuccessfull());
    }
    else if (response.item1 == false && response.item2 == "Socket") {

      emit(ChangesStatusMessage("Nemožno zmeniť hlas. Si pripojený na internet?"));
    }
    else if(response.item1 == false && response.item2 == "NotExist"){

      emit(ChangesStatusMessage("Zadaný event neexistuje"));
    }
  }

  /*editsClickedIncrease(TypeEnum type){
    editsClicked++;

    checkSaveButton(type);
  }

  editsClickedDecrease(TypeEnum type){
    editsClicked--;

    checkSaveButton(type);
  }

  checkSaveButton(TypeEnum type){
    if(editsClicked == 1){
      emit(ChangesSave(type));
    }
    else if(editsClicked == 0){
      emit(ChangesInitial());
    }
  }*/
}
