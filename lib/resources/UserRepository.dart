
import '../models/User.dart';

class UserRepository{
  late User _user;

  //TODO - try to get user from local storage - part of authentication cubit
  User getUser(){
      return _user;
  }

  void setUser(User user){
    _user = user;
  }

}