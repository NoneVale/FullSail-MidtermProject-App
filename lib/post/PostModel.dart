import 'package:fs_midterm_application/post/comment/CommentModel.dart';
import 'package:fs_midterm_application/user/UserModel.dart';

class PostModel {
  String body;
  int millisAgo;
  UserModel author;
  List<CommentModel> comments;

  PostModel(String body, int millisAgo, UserModel author) {
    this.body = body;
    this.millisAgo = millisAgo;
    this.author = author;
    this.comments = [];
  }
}