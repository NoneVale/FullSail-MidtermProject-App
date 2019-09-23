import 'package:http/http.dart' as http;

class UserModel {
   String username;
   String email;
   String birthday;

   bool verified;

   UserModel(String username, String email, String birthday, bool verified) {
     this.username = username;
     this.email = email;
     this.birthday = birthday;
     this.verified = verified;
   }

   factory UserModel.fromJson(Map<String, dynamic> parsedJson) {
     return new UserModel(parsedJson['username'], parsedJson['email'], parsedJson['birthday'], parsedJson['verified']);
   }

   Future<UserModel> fromId(String id) async {
     String apiUrl = "http://167.114.114.217:8080/users/fromid/" + id;
     var response = await http.get(apiUrl);
     if (response.statusCode == 200 && response.body.isNotEmpty) {

     }

     return null;
   }
}