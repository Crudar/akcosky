import 'dart:core';
import 'package:akcosky/Helpers/EventInvitedToMap.dart';
import 'package:akcosky/models/Event_.dart';
import 'dart:io';
import 'package:akcosky/models/User.dart';
import 'package:akcosky/models/Domain/UserDomain.dart';
import 'package:akcosky/models/UserIdentifier.dart';
import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:akcosky/AppSettings.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:tuple/tuple.dart';

import '../models/Group.dart';

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
  
  Future<UserDomain> getUser(String username) async{
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

      UserDomain userDomain = UserDomain(id.toString(), username ?? "", email ?? "", passwordHash ?? "", passwordSalt ?? "", groupIDs);

      return userDomain;
    }
    else {
      return UserDomain("", "", "", "", "", List.empty());
    }
  }

  Future<List<Group>> getGroupsByID(List<String> groupIDs) async{
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

      List<Group> groups = List.empty(growable: true);

      if(output.responses?.isEmpty != true){

        output.responses?.entries.firstWhere((element) => element.key == "SKUPINY").value.forEach((element) {
          String id = element.entries.firstWhereOrNull((element) => element.key == "ID")?.value.s ?? "";
          String adminID = element.entries.firstWhereOrNull((element) => element.key == "AdminID")?.value.s ?? "";
          String inviteCode = element.entries.firstWhereOrNull((element) => element.key == "InviteCode")?.value.s ?? "";
          String title = element.entries.firstWhereOrNull((element) => element.key == "Názov")?.value.s ?? "";

          groups.add(Group(id, adminID, inviteCode, title));
        });

        return groups;
      }
      else {
        return groups;
      }
    }
    else{
      return List.empty();
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

  Future<void> getUsersForGroups(List<Group> groups) async{
    String tableName_ = "Uzivatelia";

    String filterExpression_ = '';
    Map<String, AttributeValue> request = {};

    int incr = 0;
    for(var element in groups){
      String group_ =  ":group" + incr.toString();

      if(filterExpression_.isEmpty){
        filterExpression_ += "contains (Skupiny, " + group_ + ")";
      }
      else{
        filterExpression_ += " OR contains (Skupiny, " + group_ + ")";
      }
      incr++;

      request.addEntries([MapEntry(group_, AttributeValue(s: element.id))]);
    }

    ScanOutput output = await service.scan(tableName: tableName_,
        filterExpression: filterExpression_,
        expressionAttributeValues: request);

    if(output.count != 0) {
      output.items?.forEach((element) {
        String id = element.entries.firstWhereOrNull((element) => element.key == "ID")?.value.s ?? "";
        String login = element.entries.firstWhereOrNull((element) => element.key == "Meno_login")?.value.s ?? "";
        List<String> groupsGetted = element.entries.firstWhereOrNull((element) => element.key == "Skupiny")?.value.ss ?? List.empty();

        UserIdentifier identifier = UserIdentifier(id: id,login: login);

        for(Group group in groups){
          if(groupsGetted.contains(group.id)){
            group.users.add(identifier);
          }
        }
      });
    }
  }

  Future<bool> createEvent(Event_ event) async{
    String tableName_ = "AKCIE";

    Map<String, AttributeValue> item = {};
    item.addEntries([MapEntry("ID", AttributeValue(s: event.ID))]);
    item.addEntries([MapEntry("Názov", AttributeValue(s: event.name))]);
    item.addEntries([MapEntry("Popis", AttributeValue(s: event.description))]);
    item.addEntries([MapEntry("Miesto", AttributeValue(s: event.place))]);
    item.addEntries([MapEntry("DátumZačiatok", AttributeValue(s: event.startDate))]);
    item.addEntries([MapEntry("DátumKoniec", AttributeValue(s: event.endDate))]);
    item.addEntries([MapEntry("Transport", AttributeValue(s: event.transport))]);
    item.addEntries([MapEntry("Ubytovanie", AttributeValue(s: event.accommodation))]);
    item.addEntries([MapEntry("OdhadovanáCena", AttributeValue(n: event.estimatedAmount.toString()))]);

    Map<String, AttributeValue> mapped = EventInvitedToMap.map(event.invited);

    item.addEntries([MapEntry("Účastníci", AttributeValue(m: mapped))]);

    try{
      PutItemOutput output = await service.putItem(item: item, tableName: tableName_);

      return true;
    }
    on SocketException {
      return false;
    }
  }
}









