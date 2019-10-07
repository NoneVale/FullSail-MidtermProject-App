import 'package:fs_midterm_application/post/comment/CommentModel.dart';
import 'package:fs_midterm_application/user/UserModel.dart';

class PostModel {
  String body;
  int postTime;
  int millisSince;
  String author;
  List<CommentModel> comments;

  PostModel(String body, int millisSince, String author) {
    this.body = body;
    this.millisSince = millisSince;
    this.author = author;
  }

  factory PostModel.fromJson(Map<String, dynamic> parsedJson) {
    return new PostModel(
        parsedJson['body'], parsedJson['millisSince'], parsedJson['author']);
  }
}