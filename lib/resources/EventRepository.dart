import '../models/Domain/EventDomain.dart';
import '../models/Event_.dart';
import '../models/Vote.dart';
import 'Database.dart';
import "package:collection/collection.dart";

class EventRepository{
  List<Event_> events = List.empty(growable: true);

  Future<bool> createNewEvent(EventDomain event, List<Vote> votes) async{
    Database db = await Database.create();

    bool response = await db.createEvent(event);

    if(response){
      response = await db.createVotes(votes);
    }

    return response;
  }

  Future<List<Event_>> getEventsForUser(String userID) async{
    if(events.isEmpty){
      Database db = await Database.create();

      List<EventDomain> eventsOfUser = await db.getEventsForUser(userID);

      List<Vote> votes =  await db.getVotesForEvents(eventsOfUser);

      Map<String, List<Vote>> votesGroupedByGroup = groupBy(votes, (Vote vote) => vote.eventID);

      List<Event_> events_ = groupEventsAndVotes(eventsOfUser, votesGroupedByGroup);

      events = events_;

      return events;
    }
    else{
      return events;
    }
  }

  List<Event_> groupEventsAndVotes(List<EventDomain> eventsOfUser, Map<String, List<Vote>> votes){
    List<Event_> events = List.empty(growable: true);

    for (var element in eventsOfUser) {
      List<Vote>? votesForEvent = votes[element.ID];

      Event_ event_ = Event_(element.ID, element.name, element.description, element.type, element.place,
        element.startDate, element.endDate, votesForEvent ?? List.empty(), element.transport, element.accommodation, element.estimatedAmount, element.createdBy);

      events.add(event_);
    }
    return events;
  }
}