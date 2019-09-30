import 'package:fs_midterm_application/user/UserModel.dart';

class PostRegistrationModel {
  String body;
  UserModel author;

  PostRegistrationModel(String body, UserModel author) {
    this.body = body;
    this.author = author;
  }

  Map<String, dynamic> toJson() {
    return {
      "body": body,
      "userId": author.userId,
    };
  }
}