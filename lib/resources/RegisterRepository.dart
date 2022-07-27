
import 'package:akcosky/models/Database/UserDatabase.dart';
import 'package:akcosky/resources/Database.dart';

class RegisterRepository{
  static final RegisterRepository _singleton = RegisterRepository._internal();

  factory RegisterRepository() {
    return _singleton;
  }

  RegisterRepository._internal();

  String id = "";
  String email = "";
  String login = "";
  String password = "";
  String passSalt_ = "";
  String verificationCode = "";

  Future<bool> addUser() async{
    Database db = await Database.create();

    bool response = await db.addUserToDatabase(id, login, email, password, passSalt_);

    return response;
  }

  Future<UserDatabase?> checkIfEmailOrUsernameAlreadyExists()async{
    Database db = await Database.create();

    UserDatabase? user = await db.checkUserByEmailOrLogin(login, email);

    return user;
  }
}