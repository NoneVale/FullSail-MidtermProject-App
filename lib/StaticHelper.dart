import 'dart:convert';

import 'package:fs_midterm_application/user/UserModel.dart';
import 'package:http/http.dart' as http;

class StaticHelper {
  static Future<UserModel> getUserFromId(String id) async {
    String apiUrl = "http://167.114.114.217:8080/users/fromid/" + id;
    var response = await http.get(apiUrl);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      var jsonString = json.decode(response.body);
      return UserModel.fromJson(jsonString);
    }
    return null;
  }
}