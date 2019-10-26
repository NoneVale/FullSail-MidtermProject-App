import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_midterm_application/post/PostModel.dart';
import 'package:fs_midterm_application/screens/PostCardScreen.dart';
import 'package:fs_midterm_application/user/UserModel.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {

  PostModel postModel;
  UserModel userModel;

  PostCard(PostModel postModel, UserModel userModel) {
    this.postModel = postModel;
    this.userModel = userModel;
  }

  @override
  PostCardState createState() => new PostCardState(postModel, userModel);
}

class PostCardState extends State<PostCard> {
  var _result;

  var code = 0;

  PostModel postModel;
  UserModel userModel;
  UserModel author;

  PostCardState(PostModel postModel, UserModel userModel) {
    this.postModel = postModel;
    this.userModel = userModel;
    this.author = null;
  }

  Widget horizontalLine() => Container(
    width: ScreenUtil.getInstance().setWidth(32.0),
    height: ScreenUtil.getInstance().setHeight(1.0),
    color: Colors.black26.withOpacity(0.3),
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
    String apiUrl = "http://167.114.114.217:8080/api/users/byid/" + postModel.author;
    var response = await http.get(apiUrl);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      var jsonString = json.decode(response.body);
      UserModel userModel = UserModel.fromJson(jsonString);
      this.author = userModel;
    }
  }

  Widget postCard() {
    var since = DateTime.now().subtract(new Duration(milliseconds: postModel.millisSince));
    return new Container(
      width: double.infinity,
      //height: ScreenUtil.getInstance().setHeight(200),
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
                              image: new NetworkImage(author.profilePictureUrl.isNotEmpty ?
                              author.profilePictureUrl :
                              'https://i.nonevale.me/x5q13ki8.png')
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
                    ],
                  ),
                ),
                Spacer(),
                Text(timeago.format(since),
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(20.0),
                      color: Colors.black54
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
                Flexible(
                  child: Text(
                    postModel.body,
                    maxLines: 25,
                    softWrap: true,
                    style: TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil.getInstance().setSp(24)
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(16.0),
            ),

            Row(
              children: <Widget>[
                SizedBox(width: ScreenUtil.getInstance().setWidth(16.0),),
                Text(
                  postModel.likes.length.toString() + " Like(s)",
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(20)
                  ),
                ),
                Spacer(),
                Text(
                  postModel.comments.length.toString() + " Comment(s)",
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(20)
                  ),
                ),
                SizedBox(width: ScreenUtil.getInstance().setWidth(16.0),),
              ],
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(8.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(0.0),
                    height: ScreenUtil.getInstance().setHeight(48.0),
                    width: ScreenUtil.getInstance().setWidth(256.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.black87.withOpacity(0.02),
                        Colors.black12.withOpacity(0.05)
                      ]),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          likeButton(postModel);
                        },
                        child: Center(
                          child: Text(postModel.likes.contains(userModel.userId) ? "Liked" : "Like",
                              style: TextStyle(
                                color: postModel.likes.contains(userModel.userId) ? Colors.blueAccent : Colors.black54,
                                  fontFamily: "Poppins-Bold",
                                  fontSize: ScreenUtil.getInstance().setSp(24),
                              ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                verticalLine(),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(0.0),
                    height: ScreenUtil.getInstance().setHeight(48.0),
                    width: ScreenUtil.getInstance().setWidth(256.0),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.black87.withOpacity(0.05),
                          Colors.black87.withOpacity(0.02),
                        ]),
                        borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PostCardScreen(postModel, userModel)),
                          );
                        },
                        child: Center(
                          child: Text("Comment",
                            style: TextStyle(
                              color: Colors.black54,
                              fontFamily: "Poppins-Bold",
                              fontSize: ScreenUtil.getInstance().setSp(24),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 16.0,)
          ],
        ),
      ),
    );
  }

  Widget verticalLine() => Padding(
    padding: EdgeInsets.all(0.0),
    child: Container(
      width: ScreenUtil.getInstance().setWidth(1.0),
      height: ScreenUtil.getInstance().setHeight(48.0),
      color: Colors.black26.withOpacity(0.4),
    ),
  );

  Future<void> likeButton(PostModel post) async {
    String apiUrl = "http://167.114.114.217:8080/api/posts/" + (post.likes.contains(userModel.userId) ? "unlike" : "like") + "/" + post.postId;
    final response = await http.post(apiUrl, body: { "userId": userModel.userId});
    post.update().then((result) {
      setState(() {
        code = 1;
      });
    });
  }
}