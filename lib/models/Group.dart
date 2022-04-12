import 'package:akcosky/models/UserIdentifier.dart';

class Group{
  String id;
  String adminID;
  String inviteCode;
  String title;
  late Map<String, String> users = {};

  Group(this.id, this.adminID, this.inviteCode, this.title);
}