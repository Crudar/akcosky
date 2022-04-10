import '../models/Domain/EventDomain.dart';
import '../models/Event_.dart';
import '../models/Vote.dart';
import 'Database.dart';
import "package:collection/collection.dart";

class EventRepository{
  Map<int?, List<Event_>> events = {};

  Future<bool> createNewEvent(EventDomain event, List<Vote> votes) async{
    Database db = await Database.create();

    bool response = await db.createEvent(event);

    if(response){
      response = await db.createVotes(votes);
    }

    return response;
  }

  Future<Map<int?, List<Event_>>> getEventsForUser(String userID) async{
    if(events.isEmpty){
      Database db = await Database.create();

      List<EventDomain> eventsOfUser = await db.getEventsForUser(userID);

      List<Vote> votes =  await db.getVotesForEvents(eventsOfUser);

      Map<String, List<Vote>> votesGroupedByGroup = groupBy(votes, (Vote vote) => vote.eventID);

      Map<int?, List<Event_>> events_ = groupEventsAndVotes(eventsOfUser, votesGroupedByGroup);

      events = events_;

      return events;
    }
    else{
      return events;
    }
  }

  Map<int?, List<Event_>> groupEventsAndVotes(List<EventDomain> eventsOfUser, Map<String, List<Vote>> votes){
    List<Event_> eventsList = List.empty(growable: true);

    for (var element in eventsOfUser) {
      List<Vote>? votesForEvent = votes[element.ID];

      DateTime? startDate;
      DateTime? endDate;

      if(element.startDate != "") {
        startDate = DateTime.parse(element.startDate);
      }

      if(element.endDate != ""){
        endDate = DateTime.parse(element.endDate);
      }

      Event_ event_ = Event_(element.ID, element.name, element.description, element.type, element.place,
          startDate, endDate, votesForEvent ?? List.empty(), element.transport, element.accommodation, element.estimatedAmount, element.createdBy);

      eventsList.add(event_);
    }
    Map<int?, List<Event_>> eventsGroupedByYear = groupBy(eventsList, (Event_ event_) => event_.startDate?.year);

    return eventsGroupedByYear;
  }
}