import '../models/Database/VoteDatabase.dart';
import '../models/Group.dart';
import '../models/Vote.dart';

List<Vote> voteDatabaseAsModel(List<VoteDatabase> votesInput, Map<String, Group> groups, String selectedGroup){
  List<Vote> votes = List.empty(growable: true);

  for (var element in votesInput) {
    Group? group = groups[selectedGroup];

    Vote vote = Vote(element.voteID, element.userID, group?.users[element.userID] ?? "", element.eventID, element.vote);

    votes.add(vote);
  }

  return votes;

}