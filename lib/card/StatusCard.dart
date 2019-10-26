import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_midterm_application/post/PostModel.dart';
import 'package:fs_midterm_application/user/UserModel.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

class StatusCard extends StatefulWidget {

  UserModel userModel;

  StatusCard(UserModel userModel) {
    this.userModel = userModel;
  }

  StatusCardState cardState;

  @override
  StatusCardState createState() {
    cardState = new StatusCardState(userModel);
    return cardState;
  }
}

class StatusCardState extends State<StatusCard> {
  var _result;

  UserModel userModel;

  StatusCardState(UserModel userModel) {
    this.userModel = userModel;
  }

  Widget horizontalLine() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: ScreenUtil.getInstance().setWidth(32.0),
        height: ScreenUtil.getInstance().setHeight(1.0),
        color: Colors.black26.withOpacity(0.3),
      )
  );

  @override
  Widget build(BuildContext context) {
    return statusCard();
  }

  Widget statusCard() {
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
                                image: new NetworkImage(userModel.profilePictureUrl.isNotEmpty ?
                                userModel.profilePictureUrl :
                                'https://i.nonevale.me/x5q13ki8.png')                            )
                        ),
                      ),
                      SizedBox(width: ScreenUtil.getInstance().setWidth(24)),
                      Text("Post",
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
                  child: TextField(

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