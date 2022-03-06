import 'dart:io';

import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:akcosky/AppSettings.dart';

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
}
