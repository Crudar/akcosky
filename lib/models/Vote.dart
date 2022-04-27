import 'VoteEnum.dart';

class Vote{
  String voteID;
  String userID;
  String username;
  String eventID;
  VoteEnum vote;

  Vote(this.voteID, this.userID, this.username, this.eventID, this.vote);

  Vote copy(){
    return Vote(voteID, userID, username, eventID, vote);
  }
}