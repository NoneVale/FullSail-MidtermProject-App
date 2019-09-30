import 'package:fs_midterm_application/post/comment/CommentModel.dart';
import 'package:fs_midterm_application/user/UserModel.dart';

class PostModel {
  String body;
  int postTime;
  String author;
  List<CommentModel> comments;

  PostModel(String body, int postTime, String author) {
    this.body = body;
    this.postTime = postTime;
    this.author = author;
  }

  factory PostModel.fromJson(Map<String, dynamic> parsedJson) {
    return new PostModel(
        parsedJson['body'], parsedJson['postTime'], parsedJson['author']);
  }
}