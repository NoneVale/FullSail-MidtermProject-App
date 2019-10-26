import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_midterm_application/card/NoResultsCard.dart';
import 'package:fs_midterm_application/card/UserListCard.dart';
import 'package:fs_midterm_application/user/UserModel.dart';
import 'package:http/http.dart' as http;

class UserListScreen extends StatefulWidget {

  String page;
  List<String> userIds;
  UserModel userModel;

  UserListScreen(String page, List<String> userIds, UserModel userModel) {
    this.page = page;
    this.userIds = userIds;
    this.userModel = userModel;
  }

  @override
  UserListScreenState createState() => new UserListScreenState(page, userIds, userModel);
}

class UserListScreenState extends State<UserListScreen> {

  var _result;

  String page;
  List<String> userIds;
  UserModel userModel;

  List<UserModel> users;

  UserListScreenState(String page, List<String> userIds, UserModel userModel) {
    this.page = page;
    this.userIds = userIds;
    this.userModel = userModel;
    this.users = [];
  }

  @override
  void initState() {
    loadUsers().then((result) {
      setState(() {
        _result = "done";
      });
    });
  }

  Future<void> loadUsers() async {
    for (String s in userIds) {
      String apiUrl = "http://167.114.114.217:8080/api/users/byid/" + s;
      var response = await http.get(apiUrl);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var jsonString = json.decode(response.body);
        UserModel user = UserModel.fromJson(jsonString);
        users.add(user);
      }
    }
  }

  Widget horizontalLine() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        height: ScreenUtil.getInstance().setHeight(1.0),
        color: Colors.black26.withOpacity(0.3),
      )
  );

  @override
  Widget build(BuildContext context) {
    //loadPosts();
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 720, height: 1280, allowFontScaling: true);

    if (_result == null) {
      return new Container();
    }

    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Color(0xFF29323c), //change your color here
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          page,
          style: TextStyle(
              fontFamily: "Poppins-Medium",
              color: Colors.black
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Image.asset("assets/images/logo.png")
              ),
              Expanded(child: Container(),),
              Image.asset("assets/images/backsplash.png")
            ],
          ),
          users.length == 0 ? new NoResultsCard() : new UserListCard(userModel, users),
        ],
      ),
    );
  }
}