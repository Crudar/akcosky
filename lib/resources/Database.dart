import 'dart:io';
import 'package:akcosky/models/User.dart';
import 'package:akcosky/models/Domain/UserDomain.dart';
import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:akcosky/AppSettings.dart';
import 'package:collection/collection.dart';

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

      UserDomain userDomain = UserDomain(id.toString(), username ?? "", email ?? "", passwordHash ?? "", passwordSalt ?? "");

      return userDomain;
    }
    else {
      return UserDomain("", "", "", "", "");
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

  Future<bool> addUserToGroup(String userID_, String invitationCode_) async {
    String tableName_ = "Uzivatelia";

    List<String> groups = [invitationCode_];

    Map<String, AttributeValue> key_ = {"ID": AttributeValue(s: userID_)};

    Map<String, AttributeValue> item = {"Skupiny": AttributeValue(ss: groups)};

    // TODO - GET GROUP ID BASED ON INVITATION CODE AND REPLACE item above with group id

    try{
      UpdateItemOutput output = await service.updateItem(tableName: tableName_, key: key_, expressionAttributeValues: item);

      return true;
    }
    on SocketException {
      return false;
    }
  }
}
