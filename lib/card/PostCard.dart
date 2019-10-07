import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_midterm_application/post/PostModel.dart';
import 'package:fs_midterm_application/user/UserModel.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {

  PostModel postModel;

  PostCard(PostModel postModel) {
    this.postModel = postModel;
  }

  @override
  PostCardState createState() => new PostCardState(postModel);
}

class PostCardState extends State<PostCard> {
  var _result;

  PostModel postModel;
  UserModel author;

  PostCardState(PostModel postModel) {
    this.postModel = postModel;
    this.author = null;
  }

  Widget horizontalLine() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: ScreenUtil.getInstance().setWidth(32.0),
        height: ScreenUtil.getInstance().setHeight(1.0),
        color: Colors.black26.withOpacity(0.3),
      )
  );

  void initState () {
    if (_result == null) {
      loadAuthor().then((result) {
        setState(() {
          _result = "loaded";
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_result == null) {
      return new Container();
    }

    return postCard();
  }

  Future<void> loadAuthor() async {
    String apiUrl = "http://167.114.114.217:8080/users/byid/" + postModel.author;
    var response = await http.get(apiUrl);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      print(response.body);
      var jsonString = json.decode(response.body);
      UserModel userModel = UserModel.fromJson(jsonString);
      this.author = userModel;
    }
  }

  Widget postCard() {
    var since = DateTime.now().subtract(new Duration(milliseconds: postModel.millisSince));
    return new Container(
      width: double.infinity,
      height: ScreenUtil.getInstance().setHeight(200),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 8.0),
                blurRadius: 8.0),
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -5.0),
                blurRadius: 5.0),
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: new NetworkImage('https://i.imgur.com/eFp3FH1.png')
                          )
                        ),
                      ),
                      SizedBox(width: ScreenUtil.getInstance().setWidth(24)),
                      Text(author.username,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins-Medium",
                              fontSize: ScreenUtil.getInstance().setSp(32),
                          letterSpacing: 0.2)
                      ),
                      SizedBox(width: ScreenUtil.getInstance().setHeight(36.0)),
                      Text(timeago.format(since),
                          style: TextStyle(
                              fontFamily: "Poppins-Medium",
                              fontSize: ScreenUtil.getInstance().setSp(20.0),
                              color: Colors.black54
                          ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(16),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: ScreenUtil.getInstance().setWidth(16.0),
                ),
                Text(
                  postModel.body,
                  maxLines: null,
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(24)
                  ),
                )
              ],
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(40),
            ),
          ],
        ),
      ),
    );
  }
}