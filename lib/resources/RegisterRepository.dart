
import 'package:akcosky/resources/Database.dart';

class RegisterRepository{
  static final RegisterRepository _singleton = RegisterRepository._internal();

  factory RegisterRepository() {
    return _singleton;
  }

  RegisterRepository._internal();

  String email = "";
  String login = "";
  String password = "";
  String verificationCode = "";

  Future<bool> addUser(String id_, String username_, String email_, String passHash_, String passSalt_) async{
    Database db = await Database.create();

    bool response = await db.addUserToDatabase(id_, username_, email, passHash_, passSalt_);

    return response;
  }
}