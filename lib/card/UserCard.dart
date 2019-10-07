import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_midterm_application/post/PostModel.dart';
import 'package:fs_midterm_application/user/UserModel.dart';
import 'package:http/http.dart' as http;

class UserCard extends StatefulWidget {

  UserModel userModel, viewer;
  List<PostModel> posts;

  UserCard(UserModel userModel, UserModel viewer, List<PostModel> posts) {
    this.userModel = userModel;
    this.viewer = viewer;
    this.posts = posts;
  }

  @override
  UserCardState createState() => new UserCardState(userModel, viewer, posts);
}

class UserCardState extends State<UserCard> {
  UserModel userModel, viewer;
  List<PostModel> posts;

  UserCardState(UserModel userModel, UserModel viewer, List<PostModel> posts) {
    this.userModel = userModel;
    this.viewer = viewer;
    this.posts = posts;
  }

  Widget horizontalLine() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        height: ScreenUtil.getInstance().setHeight(1.0),
        color: Colors.black26.withOpacity(0.4),
      )
  );

  Widget verticalLine() => Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        width: ScreenUtil.getInstance().setWidth(1.0),
        height: ScreenUtil.getInstance().setHeight(48.0),
        color: Colors.black26.withOpacity(0.4),
      ),
  );

  @override
  Widget build(BuildContext context) {
    return userCard();
  }

  Widget userCard() {
    return new Container(
      width: double.infinity,
      height: ScreenUtil.getInstance().setHeight(400),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  userModel.username,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(36)
                  ),
                )
              ],
            ),
            SizedBox(height: ScreenUtil.getInstance().setHeight(8.0),),
            horizontalLine(),
            SizedBox(height: ScreenUtil.getInstance().setHeight(32.0),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 64.0,
                        height: 64.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: new NetworkImage('https://cdn.discordapp.com/attachments/525001769969909782/630535894763307009/b6f6eac70bc3f859b87911c906214bc7.png')
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        posts.length.toString(),
                        style: TextStyle(
                            fontFamily: "Poppins-Medium",
                            fontSize: ScreenUtil.getInstance().setSp(30),
                            color: Colors.black87
                        ),
                      ),
                      SizedBox(height: ScreenUtil.getInstance().setHeight(4.0),),
                      Text(
                        "Posts",
                        style: TextStyle(
                            fontFamily: "Poppins-Medium",
                            fontSize: ScreenUtil.getInstance().setSp(24),
                            color: Colors.black54
                        ),
                      )
                    ],
                  ),
                ),
                verticalLine(),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        userModel.followers.length.toString(),
                        style: TextStyle(
                            fontFamily: "Poppins-Medium",
                            fontSize: ScreenUtil.getInstance().setSp(30),
                            color: Colors.black87
                        ),
                      ),
                      SizedBox(height: ScreenUtil.getInstance().setHeight(4.0),),
                      Text(
                        "Followers",
                        style: TextStyle(
                            fontFamily: "Poppins-Medium",
                            fontSize: ScreenUtil.getInstance().setSp(24),
                            color: Colors.black54
                        ),
                      )
                    ],
                  ),
                ),
                verticalLine(),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        userModel.following.length.toString(),
                        style: TextStyle(
                            fontFamily: "Poppins-Medium",
                            fontSize: ScreenUtil.getInstance().setSp(30),
                            color: Colors.black87
                        ),
                      ),
                      SizedBox(height: ScreenUtil.getInstance().setHeight(8.0),),
                      Text(
                        "Following",
                        style: TextStyle(
                            fontFamily: "Poppins-Medium",
                            fontSize: ScreenUtil.getInstance().setSp(24),
                            color: Colors.black54
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil.getInstance().setHeight(32.0),),
            horizontalLine(),
            SizedBox(height: ScreenUtil.getInstance().setHeight(12.0),),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    userModel.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil.getInstance().setSp(26)
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}