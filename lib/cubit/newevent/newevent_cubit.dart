import 'package:akcosky/models/User.dart';
import 'package:akcosky/models/UserChip.dart';
import 'package:akcosky/models/UserIdentifier.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';

import '../../models/Group.dart';

part 'newevent_state.dart';

class NewEventCubit extends Cubit<NewEventState> {
  int stepperState = 0;
  String selectedActivityTypeIcon = "";

  Group selectedGroup = Group("", "", "", "");
  List<UserChip> usersFromSelectedGroup = List.empty(growable: true);

  bool chooseAll = false;

  NewEventCubit() : super(NewEventInitial());

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

    /*for (var element in selectedUsers) {
      usersFromSelectedGroup.add(UserChip(false, element));
    }*/
    usersFromSelectedGroup.add(UserChip(false, UserIdentifier(login: 'test', id: 'aspidojaspoid')));

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
}
