import 'Group.dart';

class User{
  String id;
  String login;
  String email;
  List<Group> groups;

  User(this.id, this.login, this.email, this.groups);
}
