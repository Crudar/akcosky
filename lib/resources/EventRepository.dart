import '../models/Event_.dart';
import 'Database.dart';

class EventRepository{
  Future<bool> createNewEvent(Event_ event) async{
    Database db = await Database.create();

    bool response = await db.createEvent(event);

    return response;
  }
}