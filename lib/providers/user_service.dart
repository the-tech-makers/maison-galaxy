import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/config.dart';

class UserService with ChangeNotifier {
  String baseurl = Config.API_BASE_URL;
  Future<String> login(String userLogin, String pwd) async {
    String url = 'https://maison.mywwwserver.in/rest/all/V1/ttm/login-api/';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-type': 'application/json'},
        body: json.encode({"username": userLogin, "password": pwd}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map user = json.decode(response.body);
        notifyListeners();
        return response.body.toString();
      } else {
        print(response.statusCode.toString());
//  throw ('Request : ${response.request} \n StatusCode: ${response.statusCode} \n Error: ${response.reasonPhrase}');
        // throw ('StatusCode: ${response.statusCode} \n Error: ${response.reasonPhrase}');
        print(response.statusCode.toString());
        Map map1 = json.decode(response.body);
        String sErrorTitle = map1['title'].toString();
        throw (sErrorTitle);
      }
    } catch (error) {
      print(error);

      throw error;
    }
  }
}
