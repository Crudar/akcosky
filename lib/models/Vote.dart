import 'package:akcosky/models/VoteEnum.dart';

class Vote{
  String voteID;
  String userID;
  String eventID;
  VoteEnum vote;

  Vote(this.voteID, this.userID, this.eventID, this.vote);
}