import 'Group.dart';

class User{
  String id;
  String login;
  String email;
  Map<String, Group> groups;

  User(this.id, this.login, this.email, this.groups);
}
