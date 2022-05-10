import 'package:akcosky/models/DateEnum.dart';
import 'package:tuple/tuple.dart';
import '../Helpers/AsModel.dart';
import '../models/Database/EventDatabase.dart';
import '../models/Event_.dart';
import '../models/Database/VoteDatabase.dart';
import '../models/Group.dart';
import '../models/Info.dart';
import '../models/TypeEnum.dart';
import '../models/User.dart';
import '../models/Vote.dart';
import 'Database.dart';
import "package:collection/collection.dart";

class EventRepository{
  Map<int?, List<Event_>> events = {};

  Future<bool> createNewEvent(EventDatabase event, List<VoteDatabase> votes) async{
    Database db = await Database.create();

    bool response = await db.createEvent(event);

    if(response){
      response = await db.createVotes(votes);
    }

    return response;
  }

  Future<Map<int?, List<Event_>>?> getEventsForUser(User user) async{
    if(events.isEmpty){
      Database db = await Database.create();

      List<EventDatabase> eventsOfUser = await db.getEventsForUser(user.id);

      if(eventsOfUser.isNotEmpty){
        List<VoteDatabase> votesDatabase =  await db.getVotesForEvents(eventsOfUser);

        Map<String, List<VoteDatabase>> votesGroupedByGroup = groupBy(votesDatabase, (VoteDatabase vote) => vote.eventID);

        Map<int?, List<Event_>> events_ = groupEventsAndVotes(eventsOfUser, votesGroupedByGroup, user.groups);

        events = events_;

        return events;
      }
      return null;
    }
    else{
      return events;
    }
  }

  Map<int?, List<Event_>> groupEventsAndVotes(List<EventDatabase> eventsOfUser, Map<String, List<VoteDatabase>> votes, Map<String, Group> groups){
    List<Event_> eventsList = List.empty(growable: true);

    for (var element in eventsOfUser) {
      List<VoteDatabase>? votesDatabaseForEvent = votes[element.ID];

      DateTime? startDate;
      DateTime? endDate;

      if(element.startDate != "") {
        startDate = DateTime.parse(element.startDate);
      }

      if(element.endDate != ""){
        endDate = DateTime.parse(element.endDate);
      }

      //TODO - toto mi pride velmi komplikovane - skust prist na nieco jednoduchsie
      List<Vote> votesForEvent = voteDatabaseAsModel(votesDatabaseForEvent ?? List.empty(), groups, element.group);
      Map<TypeEnum, Info> info = {};

      Map<DateEnum, DateTime?> dates = {};
      dates[DateEnum.startDate] = startDate;
      dates[DateEnum.endDate] = endDate;

      info[TypeEnum.place] = Info(TypeEnum.place, element.place);
      info[TypeEnum.dates] = Info(TypeEnum.dates, dates);

      if(element.transport != "") {
        info[TypeEnum.transport] = Info(TypeEnum.transport, element.transport);
      }

      if(element.accommodation != "") {
        info[TypeEnum.accommodation] = Info(TypeEnum.accommodation, element.accommodation);
      }

      if(element.estimatedAmount != 0.0) {
        info[TypeEnum.estimatedAmount] = Info(TypeEnum.estimatedAmount, element.estimatedAmount.toString());
      }

      Event_ event_ = Event_(element.ID, element.name, element.description, votesForEvent, element.createdBy, element.group, element.type, info);

      eventsList.add(event_);
    }

    Map<int?, List<Event_>> eventsGroupedByYear = groupBy(eventsList, (Event_ event_) => event_.info[TypeEnum.dates]?.value[DateEnum.startDate].year as int);

    return eventsGroupedByYear;
  }

  Future<Tuple2<bool, String>> updateUserVote(Vote vote) async {
    Database db = await Database.create();

    Tuple2<bool, String> response = await db.updateUserFoteForEvent(vote);

    return response;
  }

  Future<Tuple2<bool, String>> updateEvent(String eventID, Map<String, String> valuesToUpdate) async{
    Database db = await Database.create();

    Tuple2<bool, String> response = await db.updateEvent(eventID, valuesToUpdate);

    return response;
  }
}