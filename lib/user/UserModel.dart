import 'dart:convert';

import 'package:http/http.dart' as http;

class UserModel {
   String username;
   String email;
   String birthday;
   String userId;
   String profilePictureUrl;
   String name = "";

   List<String> followers;
   List<String> following;

   bool verified;

   UserModel(String username, String email, String birthday, String userId, String profilePictureUrl, String name, List<dynamic> followers, List<dynamic> following, bool verified) {
     this.username = username;
     this.email = email;
     this.birthday = birthday;
     this.userId = userId;
     this.profilePictureUrl = profilePictureUrl;
     this.name = name;

     this.followers = [];
     this.following = [];
     for (String s in followers) {
       this.followers.add(s);
     }

     for (String s in following) {
       this.following.add(s);
     }

     this.verified = verified;
   }

   factory UserModel.fromJson(Map<String, dynamic> parsedJson) {
     return new UserModel(
         parsedJson['username'],
         parsedJson['email'],
         parsedJson['birthday'],
         parsedJson['userId'],
         parsedJson['profilePictureUrl'],
         parsedJson['name'],
         parsedJson['followers'],
         parsedJson['following'],
         parsedJson['verified']);
   }

   Future<void> update() async {
     String apiUrl = "http://167.114.114.217:8080/api/users/byid/" + this.userId;
     var response = await http.get(apiUrl);
     if (response.statusCode == 200 && response.body.isNotEmpty) {
       var jsonString = json.decode(response.body);
       this.username = jsonString['username'];
       this.email = jsonString['email'];
       this.birthday = jsonString['birthday'];
       this.userId = jsonString['userId'];
       this.profilePictureUrl = jsonString['profilePictureUrl'];
       this.name = jsonString['name'];
       this.followers.clear();
       for (String s in jsonString['followers']) {
         this.followers.add(s);
       }
       this.following.clear();
       for (String s in jsonString['following']) {
         this.following.add(s);
       }
       this.verified = jsonString['verified'];
     }
   }
}