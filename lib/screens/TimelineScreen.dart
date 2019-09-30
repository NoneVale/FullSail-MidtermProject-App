import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_midterm_application/card/PostCard.dart';
import 'package:fs_midterm_application/post/PostModel.dart';
import 'package:fs_midterm_application/post/PostRegistrationModel.dart';
import 'package:fs_midterm_application/user/UserModel.dart';
import 'package:http/http.dart' as http;

class TimelineScreen extends StatefulWidget {

  UserModel userModel;

  TimelineScreen(UserModel userModel) {
    this.userModel = userModel;
  }

  @override
  TimelineScreenState createState() => new TimelineScreenState(userModel);
}

class TimelineScreenState extends State<TimelineScreen> {

  var _result;

  UserModel userModel;
  List<PostModel> posts;

  TimelineScreenState(UserModel userModel) {
    this.userModel = userModel;

    posts = [];
  }

  //@override
  void initState() {
    getPosts().then((result) {
      setState(() {
        _result = "done";
      });
    });
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
    //loadPosts();
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 720, height: 1280, allowFontScaling: true);

    if (_result == null) {
      return new Container();
    }

    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
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
          Padding(
            padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 40.0),
            child: Column(
              children: <Widget>[
                postForm(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 28, right: 28, top: ScreenUtil.getInstance().setHeight(420.0 + 40.0 + (lines * 40))),
            child: timelineList(context),
          )
        ],
      ),
    );
  }

  Future<void> getPosts() async {
    String apiUrl = "http://167.114.114.217:8080/";
    var postListResponse = await http.get(apiUrl + "posts/" + userModel.userId);
    if (postListResponse.statusCode == 200 && postListResponse.body.isNotEmpty) {
      List<dynamic> jsonList = json.decode(postListResponse.body);
      for (dynamic dyn in jsonList) {
        PostModel post = PostModel.fromJson(dyn);
        this.posts.add(post);
      }
    }
  }

  ListView timelineList(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (_, index) {
        return new Column(
          children: <Widget>[
            new PostCard(posts[index]),
            SizedBox(height: ScreenUtil.getInstance().setHeight(20.0),)
          ],
        );
      },
    );
  }

  var _statusController = new TextEditingController();

  int lines = 0;

  bool _isBlank = false;

  void _toggleIsBlank(bool val) {
    setState(() {
      _isBlank = val;
    });
  }

  Widget postForm() {
    return new Container(
      width: double.infinity,
      height: ScreenUtil.getInstance().setHeight(375.0 + (lines * 40.0)),
      constraints: BoxConstraints(
        minHeight: ScreenUtil.getInstance().setHeight(350.0),
        maxHeight: ScreenUtil.getInstance().setHeight(1200.0),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 15.0),
                blurRadius: 15.0),
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -10.0),
                blurRadius: 10.0),
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Flexible(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 35.0,
                        height: 35.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: new NetworkImage('https://i.imgur.com/eFp3FH1.png')
                            )
                        ),
                      ),
                      SizedBox(width: ScreenUtil.getInstance().setWidth(16)),
                      Text("Post",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins-Medium",
                              fontSize: ScreenUtil.getInstance().setSp(32),
                              letterSpacing: 0.2)
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(16),
                  ),
                  TextField(
                    controller: _statusController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    onChanged: (text) {
                      setState(() {
                        lines = '\n'.allMatches(text).length;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "Status",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(40),
                  ),
                  InkWell(
                    child: Container(
                      width: ScreenUtil.getInstance().setWidth(250),
                      height: ScreenUtil.getInstance().setHeight(75),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color(0xFF29323c),
                            Color(0xFF485563),
                          ]),
                          borderRadius: BorderRadius.circular(6.0),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xFF6078ea).withOpacity(.3),
                                offset: Offset(0.0, 8.0),
                                blurRadius: 8.0)
                          ]),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            post(context);
                          },
                          child: Center(
                            child: Text("Post",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Poppins-Bold",
                                    fontSize: 18,
                                    letterSpacing: 1.0)
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),-
          ],
        ),
      ),
    );
  }

  void checkIsBlank() {
    _toggleIsBlank(_statusController.text.isEmpty);
  }

  Future<void> post(BuildContext context) async {
    checkIsBlank();
    if (_isBlank) return;

    final postForm = new PostRegistrationModel(_statusController.text, userModel);
    print(postForm.toJson());

    String apiUrl = "http://167.114.114.217:8080/";
    final response = await http.post(apiUrl + "posts/register", body: postForm.toJson());

    print(response.body);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TimelineScreen(userModel)),
    );
  }
}