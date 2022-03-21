import 'package:akcosky/resources/Database.dart';
import 'package:tuple/tuple.dart';

class GroupsRepository{
  Future<bool> createNewGroup(String id_, String adminID_, String inviteCode_, String groupName_) async{
    Database db = await Database.create();

    bool response = await db.createNewGroup(id_, adminID_, inviteCode_, groupName_);

    return response;
  }

  Future<Tuple2<bool, String>> addUserToGroup(String userID_, String invitationCode_) async {
    Database db = await Database.create();

    Tuple2<bool, String> response = await db.addUserToGroup(userID_, invitationCode_);

    return response;
  }
}