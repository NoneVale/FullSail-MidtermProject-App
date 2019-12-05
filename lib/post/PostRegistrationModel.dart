import 'package:fs_midterm_application/user/UserModel.dart';

class PostRegistrationModel {
  String body;
  UserModel author;
  String photoUrl;

  PostRegistrationModel(String body, UserModel author, String photoUrl) {
    this.body = body;
    this.author = author;
    this.photoUrl = photoUrl;
  }

  Map<String, dynamic> toJson() {
    return {
      "body": body,
      "userId": author.userId,
      "photoUrl" : photoUrl,
    };
  }
}