import 'package:akcosky/models/VoteEnum.dart';

class Vote{
  String ID;
  String userID;
  VoteEnum vote;

  Vote(this.ID, this.userID, this.vote);
}