import 'package:akcosky/models/UserIdentifier.dart';
import 'package:aws_dynamodb_api/dynamodb-2011-12-05.dart';

import 'Vote.dart';

class Event_{
  String ID;
  String name;
  String description;
  String type;
  String place;
  String startDate;
  String endDate;
  List<String> votesReference;
  String transport;
  String accommodation;
  double estimatedAmount;
  String createdBy;

  Event_(this.ID, this.name, this.description, this.type, this.place, this.startDate, this.endDate, this.votesReference,
      this.transport, this.accommodation, this.estimatedAmount, this.createdBy);
}