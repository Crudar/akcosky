import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class AppSettings{
  static Future<String> Load(String whatToLoad) async{
    final contents = await rootBundle.loadString(
      'assets/config/appsettings.json',
    );

    Map<String, dynamic> data = jsonDecode(contents);

    return data[whatToLoad];
  }

  static Future<String> LoadAWSAccessKey() async {
    String aws_access_key = await Load("AWS_access_key");

    return aws_access_key;
  }

  static Future<String> LoadAWSSecretKey() async {
    String aws_secret_key = await Load("AWS_secret_key");

    return aws_secret_key;
  }
}