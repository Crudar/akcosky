import 'package:akcosky/models/UserIdentifier.dart';
import 'package:aws_dynamodb_api/dynamodb-2011-12-05.dart';

import 'VoteDatabase.dart';

class EventDatabase{
  String ID;
  String name;
  String description;
  String type;
  String place;
  String startDate;
  String endDate;
  List<String> participantIDs;
  String transport;
  String accommodation;
  double estimatedAmount;
  String createdBy;
  String group;

  EventDatabase(this.ID, this.name, this.description, this.type, this.place, this.startDate, this.endDate, this.participantIDs,
      this.transport, this.accommodation, this.estimatedAmount, this.createdBy, this.group);

}