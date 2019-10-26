import 'package:fs_midterm_application/user/UserModel.dart';

import '../PostModel.dart';

class CommentRegistrationModel {
  String body;
  UserModel author;
  PostModel post;

  CommentRegistrationModel(String body, UserModel author, PostModel post) {
    this.body = body;
    this.author = author;
    this.post = post;
  }

  Map<String, dynamic> toJson() {
    return {
      "body": body,
      "userId": author.userId,
      "postId": post.postId
    };
  }
}