
import '../models/User.dart';

class UserRepository{
  User? _user;

  //TODO - try to get user from local storage - part of authentication cubit
  User? getUser(){
    if(_user != null){
      return _user;
    }
  }

  void setUser(User user){
    _user = user;
  }

}