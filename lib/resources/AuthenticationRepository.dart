import '../models/Domain/UserDomain.dart';
import '../models/Group.dart';
import 'Database.dart';

class AuthenticationRepository{

  Future<UserDomain?> logIn({
    required String username,
    required String password
  })async{
    Database db = await Database.create();

    UserDomain response = await db.getUser(username);

    response.groups = await db.getGroupsByID(response.groupIDs);

    return response;
  }
}