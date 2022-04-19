import '../Helpers/AsModel.dart';
import '../models/Database/EventDatabase.dart';
import '../models/Event_.dart';
import '../models/Database/VoteDatabase.dart';
import '../models/Group.dart';
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

  Future<Map<int?, List<Event_>>> getEventsForUser(User user) async{
    if(events.isEmpty){
      Database db = await Database.create();

      List<EventDatabase> eventsOfUser = await db.getEventsForUser(user.id);

      List<VoteDatabase> votesDatabase =  await db.getVotesForEvents(eventsOfUser);

      Map<String, List<VoteDatabase>> votesGroupedByGroup = groupBy(votesDatabase, (VoteDatabase vote) => vote.eventID);

      Map<int?, List<Event_>> events_ = groupEventsAndVotes(eventsOfUser, votesGroupedByGroup, user.groups);

      events = events_;

      return events;
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

      Event_ event_ = Event_(element.ID, element.name, element.description, element.type, element.place,
          startDate, endDate, votesForEvent, element.transport, element.accommodation, element.estimatedAmount, element.createdBy, element.group);

      eventsList.add(event_);
    }
    Map<int?, List<Event_>> eventsGroupedByYear = groupBy(eventsList, (Event_ event_) => event_.startDate?.year);

    return eventsGroupedByYear;
  }
}