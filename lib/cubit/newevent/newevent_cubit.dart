import 'package:akcosky/models/Domain/EventDomain.dart';
import 'package:akcosky/models/User.dart';
import 'package:akcosky/models/UserChip.dart';
import 'package:akcosky/models/UserIdentifier.dart';
import 'package:akcosky/models/VoteEnum.dart';
import 'package:akcosky/resources/EventRepository.dart';
import 'package:aws_dynamodb_api/dynamodb-2011-12-05.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../models/Group.dart';
import '../../models/Vote.dart';

part 'newevent_state.dart';

class NewEventCubit extends Cubit<NewEventState> {
  final EventRepository eventRepository;

  int stepperState = 0;
  String selectedActivityTypeIcon = "";
  bool moreDayAction = false;
  String dateText = 'Vyber dátum konania akcie';

  late DateTime? date_;
  late DateTimeRange dateRange;

  Group selectedGroup = Group("", "", "", "");
  Map<String, UserChip> usersFromSelectedGroup = {};

  bool chooseAll = false;

  NewEventCubit(this.eventRepository) : super(NewEventInitial());

  updateStepperState(int state){
    stepperState = state;

    emit(NewEventInitial());
  }

  updateSelectedActivityType(int index, path){
    selectedActivityTypeIcon = path;

    emit(NewEventInitial());
  }

  updateSelectedGroup(Group group){
    selectedGroup = group;

    usersFromSelectedGroup = group.users.map((key, value) => MapEntry(key, UserChip(false, UserIdentifier(id: key, login: value))));

    emit(NewEventInitial());
  }

  updateSelectedUser(String userID){
    UserChip? user = usersFromSelectedGroup[userID];

    if(user != null) {
      user.selected = !user.selected;
    }

    emit(NewEventInitial());
  }

  updateAllUsersInSelectedGroup(){
    chooseAll = !chooseAll;
    usersFromSelectedGroup.forEach((key, value) {
      if(chooseAll) {
        value.selected = true;
      }
      else{
        value.selected = false;
      }
    });

    emit(NewEventInitial());
  }

  updateMoreDayCheckbox(){
    moreDayAction = !moreDayAction;

    emit(NewEventInitial());
  }

  updateDate(DateTime? date){
    var formatter = DateFormat('dd.MM.yyyy');

    if(date != null){
      dateText = formatter.format(date);
    }
    else{
      dateText = "Vyber dátum a čas akcie";
    }

    date_ = date?.toLocal();

    emit(NewEventInitial());
  }

  updateDateRange(DateTimeRange? range){
    var formatter = DateFormat('dd.MM.yyyy');

    if(range != null){
      String dateStart = formatter.format(range.start);
      String dateEnd = formatter.format(range.end);

      dateText = dateStart + " - " + dateEnd;
    }
    else{
      dateText = "Vyber dátum a čas akcie";
    }

    dateRange = range!;

    emit(NewEventInitial());
  }

  updateTime(TimeOfDay? time){
    int hour = time?.hour ?? 0;
    int minute = time?.minute ?? 0;

    var formatterDate = DateFormat('dd.MM.yyyy');
    var formatterTime = DateFormat.Hm();

    date_ = date_?.add(Duration(hours: hour, minutes: minute));

    if(date_ != null){
      dateText = formatterDate.format(date_!) + " " + formatterTime.format(date_!);
    }
    else{
      dateText = "Vyber dátum a čas akcie";
    }

    emit(NewEventInitial());

  }

  finishCreation(String title, String description, String place, String transport, String accommodation, String estimatedPrice,
      String createdBy) async {
    double estimatedPriceDouble = 0;
    late EventDomain event_;

    if(estimatedPrice != ""){
      var estimatedPriceDouble_ = double.parse(estimatedPrice);
      assert(estimatedPriceDouble_ is double);

      estimatedPriceDouble = estimatedPriceDouble_;
    }

    List<String> participantIDs = List.empty(growable: true);
    List<Vote> votes = List.empty(growable: true);

    var uuid = const Uuid();

    var eventID_ = uuid.v4();

    usersFromSelectedGroup.forEach((key, value) {
      if(value.selected == true) {
        var reference = uuid.v4();

        participantIDs.add(value.user.id);
        votes.add(Vote(reference, value.user.id, eventID_, VoteEnum.undefined));
      }
    });

    if(!moreDayAction){
      event_ = EventDomain(eventID_, title, description, selectedActivityTypeIcon, place,
        date_?.toIso8601String() ?? "", "", participantIDs, transport, accommodation, estimatedPriceDouble, createdBy);
    }
    else{
      event_ = EventDomain(eventID_, title, description, selectedActivityTypeIcon, place,
          dateRange.start.toIso8601String(), dateRange.end.toIso8601String(), participantIDs, transport, accommodation,
          estimatedPriceDouble, createdBy);
    }

    bool response = await eventRepository.createNewEvent(event_, votes);

    if(response){
      emit(NewEventFinish());
    }else{
      emit(NewEventError("Nemožno vytvoriť akciu. Si pripojený na internet?"));
    }
  }
}
