import 'package:akcosky/resources/Database.dart';

class GroupsRepository{
  Future<bool> createNewGroup(String id_, String adminID_, String inviteCode_, String groupName_) async{
    Database db = await Database.create();

    bool response = await db.createNewGroup(id_, adminID_, inviteCode_, groupName_);

    return response;
  }

  Future<bool> addUserToGroup(String userID_, String invitationCode_) async {
    Database db = await Database.create();

    bool response = await db.addUserToGroup(userID_, invitationCode_);

    return response;
  }
}