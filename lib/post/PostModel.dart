import 'dart:convert';

import 'package:http/http.dart' as http;

class PostModel {

  String postId;
  String body;
  int millisSince;
  String author;
  List<String> likes;
  List<String> comments;

  PostModel(String postId, String body, int millisSince, String author, List<dynamic> likes, List<dynamic> comments) {
    this.postId = postId;
    this.body = body;
    this.millisSince = millisSince;
    this.author = author;

    this.likes = [];
    for (String s in likes) {
      this.likes.add(s);
    }

    this.comments = [];
    for (String s in comments) {
      this.comments.add(s);
    }
  }

  factory PostModel.fromJson(Map<String, dynamic> parsedJson) {
    return new PostModel(
        parsedJson['postId'], parsedJson['body'], parsedJson['millisSince'], parsedJson['author'], parsedJson['likes'], parsedJson['comments']);
  }

  Future<void> update() async {
    String apiUrl = "http://167.114.114.217:8080/api/posts/byid/" + this.postId;
    var response = await http.get(apiUrl);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      var jsonString = json.decode(response.body);
      this.postId = jsonString['postId'];
      this.body = jsonString['body'];
      this.millisSince = jsonString['millisSince'];
      this.author = jsonString['author'];

      this.likes.clear();
      for (String s in jsonString['likes']) {
        this.likes.add(s);
      }

      this.comments.clear();
      for (String s in jsonString['comments']) {
        this.comments.add(s);
      }
    }
  }
}