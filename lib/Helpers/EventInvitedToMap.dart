import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';

class EventInvitedToMap{
  static Map<String, AttributeValue> map(Map<String,bool> users){
    Map<String, AttributeValue> invitedToDB = {};

    users.forEach((key, value) {
      invitedToDB.addEntries([MapEntry(key, AttributeValue(n: 0.toString()))]);
    });
    return invitedToDB;
  }
}