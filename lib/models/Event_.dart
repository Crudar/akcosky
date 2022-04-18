import 'package:akcosky/models/VoteEnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'Vote.dart';

class Event_{
  String ID;
  String name;
  String description;
  String type;
  String place;
  DateTime? startDate;
  DateTime? endDate;
  List<Vote> votes;
  String transport;
  String accommodation;
  double estimatedAmount;
  String createdBy;

  Event_(this.ID, this.name, this.description, this.type, this.place, this.startDate, this.endDate, this.votes,
      this.transport, this.accommodation, this.estimatedAmount, this.createdBy);

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
    if(endDate == null && startDate != null){
      var formatterDate = DateFormat('dd');
      var formatterMonth = DateFormat('MMMM');
      var formatterTime = DateFormat.Hm();

      return formatterDate.format(startDate!) + "\n" + formatterMonth.format(startDate!).substring(0, 3) + "\n" + formatterTime.format(startDate!);
    }
    else{
      var formatterDate = DateFormat('dd.MM.');

      return formatterDate.format(startDate!) + "\n-\n" + formatterDate.format(endDate!);
    }
  }
}