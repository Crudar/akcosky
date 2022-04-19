import 'package:akcosky/models/VoteEnum.dart';

class VoteDatabase{
  String voteID;
  String userID;
  String eventID;
  VoteEnum vote;

  VoteDatabase(this.voteID, this.userID, this.eventID, this.vote);
}