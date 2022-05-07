import 'package:akcosky/models/DateEnum.dart';
import 'package:akcosky/models/VoteEnum.dart';
import 'package:intl/intl.dart';
import 'Info.dart';
import 'Vote.dart';
import 'TypeEnum.dart';

class Event_{
  String ID;
  String name;
  String description;
  List<Vote> votes;
  String createdBy;
  String group;
  String type;
  Map<TypeEnum, Info> info;

  Event_(this.ID, this.name, this.description, this.votes, this.createdBy, this.group, this.type, this.info);

  int comingParticipants(){
    int coming = 0;

    for (var vote in votes) {
      if(vote.vote == VoteEnum.yes){
        coming++;
      }
    }
    return coming;
  }

  List<int> participantsVotes(){
    List<int> counts = List.empty(growable: true);
    
    counts.add(votes.where((element) => element.vote == VoteEnum.yes).toList().length);
    counts.add(votes.where((element) => element.vote == VoteEnum.no).toList().length);
    counts.add(votes.where((element) => element.vote == VoteEnum.undefined).toList().length);

    return counts;
  }

  String getDate(){
    Map<DateEnum, DateTime?> dates = info[TypeEnum.dates]?.value;

    DateTime? endDate = dates[DateEnum.endDate];
    DateTime? startDate = dates[DateEnum.startDate];

    if(endDate == null && startDate != null){
      List months = ['Január','Február','Marec','Apríl','Máj','Jún','Júl','August','September','Október','November','December'];

      var formatterDate = DateFormat('dd');
      var formatterTime = DateFormat.Hm();

      int? month = startDate.month;
      month = month - 1;

      return formatterDate.format(startDate) + "\n" + months[month].substring(0, 3) + "\n" + formatterTime.format(startDate);
    }
    else{
      var formatterDate = DateFormat('dd.MM.');

      return formatterDate.format(startDate!) + "\n-\n" + formatterDate.format(endDate!);
    }
  }
}