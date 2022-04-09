import 'Vote.dart';

class Event_{
  String ID;
  String name;
  String description;
  String type;
  String place;
  String startDate;
  String endDate;
  List<Vote> votes;
  String transport;
  String accommodation;
  double estimatedAmount;
  String createdBy;

  Event_(this.ID, this.name, this.description, this.type, this.place, this.startDate, this.endDate, this.votes,
      this.transport, this.accommodation, this.estimatedAmount, this.createdBy);

}