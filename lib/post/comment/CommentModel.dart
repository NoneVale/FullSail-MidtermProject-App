import 'dart:convert';

import 'package:fs_midterm_application/user/UserModel.dart';
import 'package:http/http.dart' as http;

class CommentModel {

  String postId;
  String commentId;
  String body;
  int millisSince;
  String authorId;
  UserModel author;
  List<String> likes;

  CommentModel(String postId, String commentId, String body, int millisSince, String authorId, List<dynamic> likes) {
    this.postId = postId;
    this.commentId = commentId;
    this.body = body;
    this.millisSince = millisSince;
    this.authorId = authorId;

    this.likes = [];
    for (String s in likes) {
      this.likes.add(s);
    }
  }

  factory CommentModel.fromJson(Map<String, dynamic> parsedJson) {
    return new CommentModel(
        parsedJson['postId'], parsedJson['commentId'], parsedJson['body'], parsedJson['millisSince'], parsedJson['author'], parsedJson['likes']
    );
  }

  Future<void> update() async {
    String apiUrl = "http://167.114.114.217:8080/api/comments/byid/" + this.commentId;
    var response = await http.get(apiUrl);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      var jsonString = json.decode(response.body);
      this.postId = jsonString['postId'];
      this.commentId = jsonString['commentId'];
      this.body = jsonString['body'];
      this.millisSince = jsonString['millisSince'];
      this.authorId = jsonString['author'];

      this.likes.clear();
      for (String s in jsonString['likes']) {
        this.likes.add(s);
      }
    }
  }
}