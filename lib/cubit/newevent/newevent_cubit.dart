import 'package:akcosky/models/Event_.dart';
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
  List<UserChip> usersFromSelectedGroup = List.empty(growable: true);

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

  updateSelectedGroup(Group group, List<UserIdentifier> selectedUsers){
    selectedGroup = group;

    usersFromSelectedGroup.clear();

    for (var element in selectedUsers) {
      usersFromSelectedGroup.add(UserChip(false, element));
    }

    emit(NewEventInitial());
  }

  updateSelectedUser(UserIdentifier user){
    for (var value in usersFromSelectedGroup) {
      if(user == value.user){
        value.selected = !value.selected;
      }
    }
    emit(NewEventInitial());
  }

  updateAllUsersInSelectedGroup(){
    chooseAll = !chooseAll;
    for (var value in usersFromSelectedGroup) {
      if(chooseAll) {
        value.selected = true;
      }
      else{
        value.selected = false;
      }
    }

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
    late Event_ event_;

    if(estimatedPrice != ""){
      var estimatedPriceDouble_ = double.parse(estimatedPrice);
      assert(estimatedPriceDouble_ is double);

      estimatedPriceDouble = estimatedPriceDouble_;
    }

    List<Vote> votes = List.empty(growable: true);
    List<String> votesReference = List.empty(growable: true);

    var uuid = const Uuid();

    for (var element in usersFromSelectedGroup) {
      if(element.selected == true) {
        var reference = uuid.v4();

        votesReference.add(reference);
        votes.add(Vote(reference, element.user.id, VoteEnum.undefined));
      }
    }

    var id_ = uuid.v4();

    if(!moreDayAction){
      event_ = Event_(id_, title, description, selectedActivityTypeIcon, place,
        date_?.toIso8601String() ?? "", "", votesReference, transport, accommodation, estimatedPriceDouble, createdBy);
    }
    else{
      event_ = Event_(id_, title, description, selectedActivityTypeIcon, place,
          dateRange.start.toIso8601String(), dateRange.end.toIso8601String(), votesReference, transport, accommodation,
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
