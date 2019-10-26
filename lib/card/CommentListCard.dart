import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_midterm_application/card/NoCommentsCard.dart';
import 'package:fs_midterm_application/post/PostModel.dart';
import 'package:fs_midterm_application/post/comment/CommentModel.dart';
import 'package:fs_midterm_application/screens/UserCardScreen.dart';
import 'package:fs_midterm_application/user/UserModel.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

class CommentListCard extends StatefulWidget {

  PostModel postModel;
  UserModel userModel;

  CommentListCard(PostModel postModel, UserModel userModel) {
    this.postModel = postModel;
    this.userModel = userModel;
  }

  CommentListCardState cardState;

  @override
  CommentListCardState createState() {
    cardState = new CommentListCardState(postModel, userModel);
    return cardState;
  }
}

class CommentListCardState extends State<CommentListCard> {

  var _result;

  int code = 0;

  PostModel postModel;
  UserModel userModel;
  List<CommentModel> comments;

  CommentListCardState(PostModel postModel, UserModel userModel) {
    this.postModel = postModel;
    this.userModel = userModel;
    this.comments = [];
  }

  Future<void> loadComments() async {
      String apiUrl = "http://167.114.114.217:8080/api/comments/" + postModel.postId;
      var response = await http.get(apiUrl);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        List<dynamic> jsonList = json.decode(response.body);
        for (dynamic dyn in jsonList) {
          CommentModel comment = CommentModel.fromJson(dyn);
          apiUrl = "http://167.114.114.217:8080/api/users/byid/" + comment.authorId;
          response = await http.get(apiUrl);
          if (response.statusCode == 200 && response.body.isNotEmpty)
            comment.author = UserModel.fromJson(json.decode(response.body));
          this.comments.add(comment);
        }
      }
  }

  Widget horizontalLine() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.0),
      child: Container(
        width: ScreenUtil.getInstance().setWidth(double.infinity),
        height: ScreenUtil.getInstance().setHeight(1.0),
        color: Colors.black26.withOpacity(0.3),
      )
  );

  @override
  void initState() {
    postModel.update().then((result) {
      loadComments().then((result2) {
        setState(() {
          _result = "done";
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    if (_result == null) {
      return new Container();
    }

    return commentListCard();
  }

  void update() {
    setState(() {
      _result = null;
    });

    postModel.update().then((result) {
      loadComments().then((result2) {
        setState(() {
          _result = "done";
        });
      });
    });
  }

  Widget commentListCard() {
    if (comments.length == 0) {
      return NoCommentsCard();
    } else {
      return new Container(
          width: double.infinity,
          height: ScreenUtil.getInstance().setHeight(600.0),
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
              padding: EdgeInsets.all(0),
              child: ListView.separated(
                  padding: EdgeInsets.all(0.0),
                  itemBuilder: (_, index) {
                    return InkWell(
                      child: Container(
                        width: ScreenUtil.getInstance().setWidth(512.0),
                        //height: ScreenUtil.getInstance().setHeight(80.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => UserCardScreen(comments[index].author, userModel)),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 16.0, left: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 8.0,
                                    ),
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
                                                        image: new NetworkImage(comments[index].author.profilePictureUrl.isNotEmpty ?
                                                        comments[index].author.profilePictureUrl :
                                                        'https://i.nonevale.me/x5q13ki8.png')
                                                    )
                                                ),
                                              ),
                                              SizedBox(width: ScreenUtil.getInstance().setWidth(24)),
                                              Text(comments[index].author.username,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "Poppins-Medium",
                                                      fontSize: ScreenUtil.getInstance().setSp(28),
                                                      letterSpacing: 0.2)
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Text(timeago.format(DateTime.now().subtract(new Duration(milliseconds: comments[index].millisSince))),
                                          style: TextStyle(
                                              fontFamily: "Poppins-Medium",
                                              fontSize: ScreenUtil.getInstance().setSp(20.0),
                                              color: Colors.black54
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          comments[index].likes.length.toString() + " Like(s)",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontFamily: "Poppins-Medium",
                                              fontSize: ScreenUtil.getInstance().setSp(20)
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: ScreenUtil.getInstance().setHeight(8),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            comments[index].body,
                                            maxLines: 25,
                                            softWrap: true,
                                            style: TextStyle(
                                                fontFamily: "Poppins-Medium",
                                                fontSize: ScreenUtil.getInstance().setSp(24)
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: ScreenUtil.getInstance().setWidth(32.0),),
                                        InkWell(
                                          child: Container(
                                            width: ScreenUtil.getInstance().setWidth(126),
                                            height: ScreenUtil.getInstance().setHeight(48),
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
                                                  likeButton(comments[index]);
                                                },
                                                child: Center(
                                                  child: Text(comments[index].likes.contains(userModel.userId) ? "Liked" : "Like",
                                                    style: TextStyle(
                                                      color: comments[index].likes.contains(userModel.userId) ? Colors.blueAccent : Colors.black54,
                                                      fontFamily: "Poppins-Bold",
                                                      fontSize: ScreenUtil.getInstance().setSp(24),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: ScreenUtil.getInstance().setHeight(8.0),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, index) {
                    return horizontalLine();
                  },
                  itemCount: comments.length
              )
          )
      );
    }
  }

  Future<void> likeButton(CommentModel comment) async {
    String apiUrl = "http://167.114.114.217:8080/api/comments/" + (comment.likes.contains(userModel.userId) ? "unlike" : "like") + "/" + comment.commentId;
    final response = await http.post(apiUrl, body: { "userId": userModel.userId });
    print(response.body);
    comment.update().then((result) {
      setState(() {
        code = 1;
      });
    });
  }
}