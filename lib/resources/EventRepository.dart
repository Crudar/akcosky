import '../models/Event_.dart';
import '../models/Vote.dart';
import 'Database.dart';

class EventRepository{
  Future<bool> createNewEvent(Event_ event, List<Vote> votes) async{
    Database db = await Database.create();

    bool response = await db.createEvent(event);

    if(response){
      response = await db.createVotes(votes);
    }

    return response;
  }

  Future<List<Event_>> getEventsForUser(String userID) async{
    Database db = await Database.create();

    List<Event_> events = await db.getEventsForUser(userID);

    return events;
  }
}