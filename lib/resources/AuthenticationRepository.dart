import '../models/Domain/UserDomain.dart';
import 'Database.dart';

class AuthenticationRepository{

  Future<UserDomain?> logIn({
    required String username,
    required String password
  })async{
    Database db = await Database.create();

    UserDomain response = await db.getUser(username);

    return response;
  }
}