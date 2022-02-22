import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:akcosky/AppSettings.dart';
import 'package:flutter/foundation.dart';

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

  String test(){
    return service.runtimeType.toString();
  }

  String startCooking() {
    return 'starting cooking!';
  }

  Database._internal();
}
