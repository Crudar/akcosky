import '../models/Database/UserDatabase.dart';
import '../models/Group.dart';
import 'Database.dart';

class AuthenticationRepository{

  Future<UserDatabase?> logIn({
    required String username,
    required String password
  })async{
    Database db = await Database.create();

    UserDatabase response = await db.getUser(username);

    response.groups = await db.getGroupsByID(response.groupIDs);

    await db.getUsersForGroups(response.groups);

    return response;
  }
}