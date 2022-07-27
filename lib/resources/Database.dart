import 'dart:core';
import 'package:akcosky/models/Database/EventDatabase.dart';
import 'dart:io';
import 'package:akcosky/models/Database/UserDatabase.dart';
import 'package:akcosky/models/VoteEnum.dart';
import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:akcosky/AppSettings.dart';
import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';

import '../models/Group.dart';
import '../models/Database/VoteDatabase.dart';
import '../models/Vote.dart';

class Database{
  static final Database _database = Database._internal();

  factory Database(){
    return _database;
  }

  late DynamoDB service;

  Database._create(DynamoDB _service){
    service = _service;
  }

  static Future<Database> create() async{
    String _accessKey = await AppSettings.LoadAWSAccessKey();
    String _secretKey = await AppSettings.LoadAWSSecretKey();

    AwsClientCredentials _credentials = AwsClientCredentials(accessKey: _accessKey, secretKey: _secretKey);

    DynamoDB _service = DynamoDB(region: 'eu-central-1', credentials: _credentials);

    var component = Database._create(_service);

    return component;
  }

  Database._internal();

  String test(){
    return service.runtimeType.toString();
  }

  String startCooking() {
    return 'starting cooking!';
  }

  Future<bool> addUserToDatabase(String id_, String username_, String email_, String passHash_, String passSalt_) async {
    String tableName_ = "Uzivatelia";

    Map<String, AttributeValue> item = {};
    item.addEntries([MapEntry("ID", AttributeValue(s: id_))]);
    item.addEntries([MapEntry("Meno_login", AttributeValue(s: username_))]);
    item.addEntries([MapEntry("Email", AttributeValue(s: email_))]);
    item.addEntries([MapEntry("Hash_HESLA", AttributeValue(s: passHash_))]);
    item.addEntries([MapEntry("Salt", AttributeValue(s: passSalt_))]);

    try{
      PutItemOutput output = await service.putItem(item: item, tableName: tableName_);

      return true;
    }
    on SocketException {
      return false;
    }
  }
  
  Future<UserDatabase> getUser(String username) async{
    String tableName_ = "Uzivatelia";

    String filterExpression_ = 'Meno_login = :m';

    Map<String, AttributeValue> request = {};
    request.addEntries([MapEntry(":m", AttributeValue(s: username))]);

    ScanOutput output = await service.scan(tableName: tableName_,
        filterExpression: filterExpression_,
        expressionAttributeValues: request);

    if(output.count != 0){
      Map<String, AttributeValue> response = output.items![0];
      String? id = response.entries.firstWhere((element) => element.key == "ID").value.s;
      String? username = response.entries.firstWhere((element) => element.key == "Meno_login").value.s;
      String? passwordHash = response.entries.firstWhere((element) => element.key == "Hash_HESLA").value.s;
      String? passwordSalt = response.entries.firstWhere((element) => element.key == "Salt").value.s;
      String? email = response.entries.firstWhere((element) => element.key == "Email").value.s;
      List<String> groupIDs = List.empty(growable: true);

      response.entries.firstWhereOrNull((element) => element.key == "Skupiny")?.value.ss?.forEach((element) {
        groupIDs.add(element);
      });

      UserDatabase userDomain = UserDatabase(id.toString(), username ?? "", email ?? "", passwordHash ?? "", passwordSalt ?? "", groupIDs);

      return userDomain;
    }
    else {
      return UserDatabase("", "", "", "", "", List.empty());
    }
  }

  Future<Map<String, Group>> getGroupsByID(List<String> groupIDs) async{
    if(groupIDs.isNotEmpty){

      String tableName_ = "SKUPINY";

      Map<String, KeysAndAttributes> request = {};
      KeysAndAttributes? keys_ = KeysAndAttributes(keys: List.empty(growable: true));

      if(groupIDs.isNotEmpty){

        for (var element in groupIDs) {
          keys_.keys.add({"ID": AttributeValue(s: element)});
        }

        if(keys_.keys.isNotEmpty){
          request = {tableName_: keys_};
        }
      }

      BatchGetItemOutput output = await service.batchGetItem(requestItems: request);

      Map<String, Group> groups = {};

      if(output.responses?.isEmpty != true){

        output.responses?.entries.firstWhere((element) => element.key == "SKUPINY").value.forEach((element) {
          String id = element.entries.firstWhereOrNull((element) => element.key == "ID")?.value.s ?? "";
          String adminID = element.entries.firstWhereOrNull((element) => element.key == "AdminID")?.value.s ?? "";
          String inviteCode = element.entries.firstWhereOrNull((element) => element.key == "InviteCode")?.value.s ?? "";
          String title = element.entries.firstWhereOrNull((element) => element.key == "Názov")?.value.s ?? "";

          groups[id] = Group(id, adminID, inviteCode, title);
        });

        return groups;
      }
      else {
        return groups;
      }
    }
    else{
      return {};
    }
  }

  Future<bool> createNewGroup(String id_, String adminID_, String inviteCode_, String groupName_) async{
    String tableName_ = "SKUPINY";

    Map<String, AttributeValue> item = {};
    item.addEntries([MapEntry("ID", AttributeValue(s: id_))]);
    item.addEntries([MapEntry("AdminID", AttributeValue(s: adminID_))]);
    item.addEntries([MapEntry("InviteCode", AttributeValue(s: inviteCode_))]);
    item.addEntries([MapEntry("Názov", AttributeValue(s: groupName_))]);

    try{
      PutItemOutput output = await service.putItem(item: item, tableName: tableName_);

      return true;
    }
    on SocketException {
      return false;
    }
  }

  Future<Tuple2<bool, String>> addUserToGroup(String userID_, String inviteCode_) async {
    String tableName_ = "Uzivatelia";

    Group gotGroup = await getGroupBasedOnInviteCode(inviteCode_);

    if(gotGroup.id != ""){
      List<String> groupIDs = [gotGroup.id];

      Map<String, AttributeValue> key_ = {"ID": AttributeValue(s: userID_)};

      Map<String, AttributeValue> item = {":s": AttributeValue(ss: groupIDs)};

      try{
        UpdateItemOutput output = await service.updateItem(tableName: tableName_, key: key_, updateExpression: "ADD Skupiny :s", expressionAttributeValues: item);

        return const Tuple2<bool, String>(true, "");
      }
      on SocketException {
        return const Tuple2<bool, String>(false, "Socket");
      }
    }else{
      return const Tuple2<bool, String>(false, "NotExist");
    }
  }

  Future<bool> createVotes(List<VoteDatabase> votes) async {
    String tableName_ = "AKCIEHLASOVANIE";

    List<WriteRequest> requests = List.empty(growable: true);

    votes.forEach((value){
      Map<String, AttributeValue> item = {};
      item.addEntries([MapEntry("ID", AttributeValue(s: value.voteID))]);
      item.addEntries([MapEntry("UserID", AttributeValue(s: value.userID))]);
      item.addEntries([MapEntry("EventID", AttributeValue(s: value.eventID))]);
      item.addEntries([MapEntry("VoteResult", AttributeValue(n: value.vote.index.toString()))]);

      requests.add(WriteRequest(putRequest: PutRequest(item: item)));
    });

    Map<String, List<WriteRequest>> mapRequest = {tableName_: requests};

    try{
      BatchWriteItemOutput output = await service.batchWriteItem(requestItems: mapRequest);

      return true;
    }
    on SocketException {
      return false;
    }
  }

  Future<Group> getGroupBasedOnInviteCode(String inviteCode) async {
    String tableName_ = "SKUPINY";

    String filterExpression_ = 'InviteCode = :i';

    Map<String, AttributeValue> request = {};
    request.addEntries([MapEntry(":i", AttributeValue(s: inviteCode))]);

    ScanOutput output = await service.scan(tableName: tableName_, filterExpression: filterExpression_, expressionAttributeValues: request);

    if(output.count != 0) {
      Map<String, AttributeValue> response = output.items![0];

      String? id = response.entries.firstWhere((element) => element.key == "ID").value.s;
      String? adminID = response.entries.firstWhere((element) => element.key == "AdminID").value.s;
      String? inviteCode = response.entries.firstWhere((element) => element.key == "InviteCode").value.s;
      String? title = response.entries.firstWhere((element) => element.key == "Názov").value.s;

      return Group(id.toString(), adminID ?? "", inviteCode ?? "", title ?? "");
    }
    else{
      return Group("", "", "", "");
    }
  }

  Future<void> getUsersForGroups(Map<String, Group> groups) async{
    if(groups.isNotEmpty){
      String tableName_ = "Uzivatelia";

      String filterExpression_ = '';
      Map<String, AttributeValue> request = {};

      int incr = 0;
      groups.forEach((key, value) {
        String group_ =  ":group" + incr.toString();

        if(filterExpression_.isEmpty){
          filterExpression_ += "contains (Skupiny, " + group_ + ")";
        }
        else{
          filterExpression_ += " OR contains (Skupiny, " + group_ + ")";
        }
        incr++;

        request.addEntries([MapEntry(group_, AttributeValue(s: key))]);
      });

      ScanOutput output = await service.scan(tableName: tableName_,
          filterExpression: filterExpression_,
          expressionAttributeValues: request);

      if(output.count != 0) {
        output.items?.forEach((element) {
          String id = element.entries.firstWhereOrNull((element) => element.key == "ID")?.value.s ?? "";
          String login = element.entries.firstWhereOrNull((element) => element.key == "Meno_login")?.value.s ?? "";
          List<String> groupsGetted = element.entries.firstWhereOrNull((element) => element.key == "Skupiny")?.value.ss ?? List.empty();

          groups.forEach((key, value) {
            if(groupsGetted.contains(key)){
              groups[key]?.users[id] = login;
            }
          });

        });
      }
    }
  }

  Future<bool> createEvent(EventDatabase event) async{
    String tableName_ = "AKCIE";

    Map<String, AttributeValue> item = {};
    item.addEntries([MapEntry("ID", AttributeValue(s: event.ID))]);
    item.addEntries([MapEntry("Nazov", AttributeValue(s: event.name))]);
    item.addEntries([MapEntry("Popis", AttributeValue(s: event.description))]);
    item.addEntries([MapEntry("Typ", AttributeValue(s: event.type))]);
    item.addEntries([MapEntry("Miesto", AttributeValue(s: event.place))]);
    item.addEntries([MapEntry("DatumZaciatok", AttributeValue(s: event.startDate))]);
    item.addEntries([MapEntry("DatumKoniec", AttributeValue(s: event.endDate))]);
    item.addEntries([MapEntry("Transport", AttributeValue(s: event.transport))]);
    item.addEntries([MapEntry("Ubytovanie", AttributeValue(s: event.accommodation))]);
    item.addEntries([MapEntry("OdhadovanaCena", AttributeValue(n: event.estimatedAmount.toString()))]);
    item.addEntries([MapEntry("Vytvoril", AttributeValue(s: event.createdBy))]);
    item.addEntries([MapEntry("Skupina", AttributeValue(s: event.group))]);

    item.addEntries([MapEntry("Ucastnici", AttributeValue(ss: event.participantIDs))]);

    try{
      PutItemOutput output = await service.putItem(item: item, tableName: tableName_);

      return true;
    }
    on SocketException {
      return false;
    }
  }

  Future<Tuple2<bool, String>> updateEvent(String eventID, Map<String, String> valuesToUpdate) async {
    String tableName_ = "AKCIE";

    if(valuesToUpdate.isNotEmpty){

      Map<String, AttributeValue> key_ = {"ID": AttributeValue(s: eventID)};

      Map<String, AttributeValue> items = {};

      String updateString = "SET ";

      valuesToUpdate.forEach((key, value) {
        String keyWithDots = ":" + key;

        updateString += key + " = " + keyWithDots + ", ";

        if(key != "OdhadovanaCena") {
          items[keyWithDots] = AttributeValue(s: value);
        }
        else{
          items[keyWithDots] = AttributeValue(n: value);
        }
      });
      
      updateString = updateString.substring(0, updateString.length - 2);

      try{
        UpdateItemOutput output = await service.updateItem(tableName: tableName_, key: key_, updateExpression: updateString, expressionAttributeValues: items);

        return const Tuple2<bool, String>(true, "");
      }
      on SocketException {
        return const Tuple2<bool, String>(false, "Socket");
      }
    }else{
      return const Tuple2<bool, String>(false, "NotExist");
    }
  }

  Future<List<VoteDatabase>> getVotesForEvents(List<EventDatabase> events) async {
    String tableName_ = "AKCIEHLASOVANIE";

    String user_ =  ":UserID";
    String event_ =  ":EventID";

    String filterExpressionUser = "";
    String filterExpressionEvent = "";

    Map<String, AttributeValue> request = {};

    int incrParticipants = 0;
    int incrEvents = 0;

    for (var event in events) {

      for (var participant in event.participantIDs) {
        String actualUser = user_ + incrParticipants.toString();

        if(filterExpressionUser.isEmpty){

          filterExpressionUser += "(UserID = " + actualUser;
        }
        else{
          filterExpressionUser += " OR UserID = " + actualUser;
        }

        request.addEntries([MapEntry(actualUser, AttributeValue(s: participant))]);

        incrParticipants++;
      }

      String actualEvent = event_ + incrEvents.toString();

      if(filterExpressionEvent.isEmpty){
        filterExpressionEvent += "(EventID = " + actualEvent;
      }
      else{
        filterExpressionEvent += " OR EventID = " + actualEvent;
      }

      request.addEntries([MapEntry(actualEvent, AttributeValue(s: event.ID))]);

      incrEvents++;
    }
    filterExpressionUser += ")";
    filterExpressionEvent += ")";

    String filterExpression_ = filterExpressionUser + " AND " + filterExpressionEvent;

    ScanOutput output = await service.scan(tableName: tableName_,
        filterExpression: filterExpression_,
        expressionAttributeValues: request);

    List<VoteDatabase> votes = List.empty(growable: true);

    if(output.count != 0) {
      output.items?.forEach((element) {
        String id = element.entries
            .firstWhereOrNull((element) => element.key == "ID")
            ?.value
            .s ?? "";

        String userID = element.entries
            .firstWhereOrNull((element) => element.key == "UserID")
            ?.value
            .s ?? "";

        String eventID = element.entries
            .firstWhereOrNull((element) => element.key == "EventID")
            ?.value
            .s ?? "";

        int vote = int.parse(element.entries
        .firstWhereOrNull((element) => element.key == "VoteResult")
        ?.value
        .n ?? "0");

        votes.add(VoteDatabase(id, userID, eventID, VoteEnum.values[vote]));
      });
    }

    return votes;
  }

  Future<List<EventDatabase>> getEventsForUser(String userID) async {
    String tableName_ = "AKCIE";

    String user_ =  ":UserID";

    String filterExpression_ = "contains (Ucastnici, " + user_ + ")";

    Map<String, AttributeValue> request = {};
    request.addEntries([MapEntry(user_, AttributeValue(s: userID))]);

    ScanOutput output = await service.scan(tableName: tableName_,
        filterExpression: filterExpression_,
        expressionAttributeValues: request);

    List<EventDatabase> events = List.empty(growable: true);

    if(output.count != 0) {
      output.items?.forEach((element) {
        String id = element.entries.firstWhereOrNull((element) => element.key == "ID")?.value.s ?? "";
        String name = element.entries.firstWhereOrNull((element) => element.key == "Nazov")?.value.s ?? "";
        String description = element.entries.firstWhereOrNull((element) => element.key == "Popis")?.value.s ?? "";
        String type = element.entries.firstWhereOrNull((element) => element.key == "Typ")?.value.s ?? "";
        String place = element.entries.firstWhereOrNull((element) => element.key == "Miesto")?.value.s ?? "";
        String startDate = element.entries.firstWhereOrNull((element) => element.key == "DatumZaciatok")?.value.s ?? "";
        String endDate = element.entries.firstWhereOrNull((element) => element.key == "DatumKoniec")?.value.s ?? "";
        List<String> participants = element.entries.firstWhereOrNull((element) => element.key == "Ucastnici")?.value.ss ?? List.empty();
        String transport = element.entries.firstWhereOrNull((element) => element.key == "Transport")?.value.s ?? "";
        String accommodation = element.entries.firstWhereOrNull((element) => element.key == "Ubytovanie")?.value.s ?? "";
        String estimatedAmount = element.entries.firstWhereOrNull((element) => element.key == "OdhadovanaCena")?.value.n ?? "";
        String createdBy = element.entries.firstWhereOrNull((element) => element.key == "Vytvoril")?.value.s ?? "";
        String group = element.entries.firstWhereOrNull((element) => element.key == "Skupina")?.value.s ?? "";

        var estimatedAmountDouble = double.parse(estimatedAmount);
        assert(estimatedAmountDouble is double);

        EventDatabase event = EventDatabase(id, name, description, type, place, startDate, endDate, participants, transport, accommodation, estimatedAmountDouble, createdBy, group);

        events.add(event);
      });
    }

    return events;
  }

  Future<Tuple2<bool, String>> updateUserFoteForEvent(Vote voteToUpdate) async{
    String tableName_ = "AKCIEHLASOVANIE";

    if(voteToUpdate.voteID != ""){

      Map<String, AttributeValue> key_ = {"ID": AttributeValue(s: voteToUpdate.voteID)};

      Map<String, AttributeValue> item = {":v": AttributeValue(n: voteToUpdate.vote.index.toString())};

      try{
        UpdateItemOutput output = await service.updateItem(tableName: tableName_, key: key_, updateExpression: "SET VoteResult = :v", expressionAttributeValues: item);

        return const Tuple2<bool, String>(true, "");
      }
      on SocketException {
        return const Tuple2<bool, String>(false, "Socket");
      }
    }else{
      return const Tuple2<bool, String>(false, "NotExist");
    }
  }


  Future<UserDatabase?> checkUserByEmailOrLogin(String usernameToCheck, String emailToCheck) async{
    String tableName_ = "Uzivatelia";

    String filterExpressionLogin_ = 'Meno_login = :m';
    String filterExpressionEmail_ = 'Email = :e';

    Map<String, AttributeValue> request = {};
    request.addEntries([MapEntry(":m", AttributeValue(s: usernameToCheck))]);
    request.addEntries([MapEntry(":e", AttributeValue(s: emailToCheck))]);

    String filterExpression_ = filterExpressionLogin_ + " OR " + filterExpressionEmail_;

    ScanOutput output = await service.scan(tableName: tableName_,
        filterExpression: filterExpression_,
        expressionAttributeValues: request);

    if(output.count != 0){
      Map<String, AttributeValue> response = output.items![0];
      String? id = response.entries.firstWhere((element) => element.key == "ID").value.s;
      String? username = response.entries.firstWhere((element) => element.key == "Meno_login").value.s;
      String? passwordHash = response.entries.firstWhere((element) => element.key == "Hash_HESLA").value.s;
      String? passwordSalt = response.entries.firstWhere((element) => element.key == "Salt").value.s;
      String? email = response.entries.firstWhere((element) => element.key == "Email").value.s;
      List<String> groupIDs = List.empty(growable: true);

      response.entries.firstWhereOrNull((element) => element.key == "Skupiny")?.value.ss?.forEach((element) {
        groupIDs.add(element);
      });

      UserDatabase userDomain = UserDatabase(id.toString(), username ?? "", email ?? "", passwordHash ?? "", passwordSalt ?? "", groupIDs);

      return userDomain;
    }
    else {
      return null;
    }
  }
}









