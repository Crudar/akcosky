import 'package:akcosky/resources/GroupsRepository.dart';
import 'package:akcosky/resources/UserRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

import '../../models/User.dart';
part 'groups_state.dart';

class GroupsCubit extends Cubit<GroupsState> {
  final GroupsRepository _groupsRepository;
  final UserRepository _userRepository;

  GroupsCubit(this._groupsRepository, this._userRepository) : super(GroupsInitial());

  Future<void> createNewGroup(String groupName_) async {

    var uuid = const Uuid();
    var id_ = uuid.v4();

    var rng = new Random();
    var inviteCode_ = rng.nextInt(900000) + 100000;

    //TODO - GET ADMINID from repository
    User? user_ = await _userRepository.getUser();

    bool response = false;

    if(user_ != null){
      response = await _groupsRepository.createNewGroup(id_, user_.id, inviteCode_.toString(), groupName_);
    }

    if (response) {
      emit(GroupsStatusMessage("Skupina bola úspešne vytvorená!"));
    } else {
      emit(GroupsStatusMessage("Nemožno vytvoriť skupinu. Si pripojený na internet?"));
    }
  }

  Future<void> addUserToGroup(String invitationCode_) async{
    Tuple2<bool, String> response = await _groupsRepository.addUserToGroup(_userRepository.getUser().id, invitationCode_);

    if (response.item1) {
      emit(GroupsStatusMessage("Bol si úspešne pridaný do skupiny!"));
    }
    else if (response.item1 == false && response.item2 == "Socket") {
      emit(GroupsStatusMessage("Nemožno pripojiť ta do skupiny. Si pripojený na internet?"));
    }
    else if(response.item1 == false && response.item2 == "NotExist"){
      emit(GroupsStatusMessage("Skupina so zadaným invite kódom neexistuje"));
    }
  }

  void copyInviteCodeToClipboard(String inviteCode){
    Clipboard.setData(ClipboardData(text: inviteCode));

    emit(GroupsStatusMessage("Invite kód bol skopírovaný!"));
  }
}
