import 'package:akcosky/models/UserIdentifier.dart';

class Group{
  String id;
  String adminID;
  String inviteCode;
  String title;
  late List<UserIdentifier> users = List.empty(growable: true);

  Group(this.id, this.adminID, this.inviteCode, this.title);
}