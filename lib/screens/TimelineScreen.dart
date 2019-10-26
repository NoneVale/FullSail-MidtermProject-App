import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_midterm_application/card/NoPostsCard.dart';
import 'package:fs_midterm_application/card/PostCard.dart';
import 'package:fs_midterm_application/post/PostModel.dart';
import 'package:fs_midterm_application/post/PostRegistrationModel.dart';
import 'package:fs_midterm_application/screens/NotificationsScreen.dart';
import 'package:fs_midterm_application/screens/SearchScreen.dart';
import 'package:fs_midterm_application/screens/UserCardScreen.dart';
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
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Color(0xFF29323c), //change your color here
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          'assets/images/text5.png',
          height: 36.0,
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
          timeLinePage(),
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
              title: Text("Home")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
              title: Text("Search")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
              title: Text("Notifications")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
              title: Text("Profile")
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blueAccent,
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen(userModel)),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen(userModel)),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserCardScreen(userModel, userModel)),
              );
              break;
          }
        },
      ),
    );
  }

  Future<void> getPosts() async {
    String apiUrl = "http://167.114.114.217:8080/api/posts/" + userModel.userId;
    var response = await http.get(apiUrl);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      List<dynamic> jsonList = json.decode(response.body);
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
            new PostCard(posts[index], userModel),
            SizedBox(height: ScreenUtil.getInstance().setHeight(20.0),)
          ],
        );
      },
    );
  }

  ListView timeLinePage() {
    if (posts.length == 0) {
      return ListView.separated(
        addAutomaticKeepAlives: false,
        itemCount: posts.length + 2,
        separatorBuilder: (_, index) {
          if (index == 0)
            return new Padding(
                padding: EdgeInsets.only(left: 28.0, right: 28.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                        height: ScreenUtil.getInstance().setHeight(10.0)
                    ),
                    //postForm(),
                    postForm(),
                    SizedBox(
                        height: ScreenUtil.getInstance().setHeight(20.0)
                    ),
                    horizontalLine(),
                    SizedBox(
                        height: ScreenUtil.getInstance().setHeight(20.0)
                    )
                  ],
                )
            );
          return new SizedBox(height: ScreenUtil.getInstance().setHeight(0.0));
        },
        itemBuilder: (_, index) {
          if (index == 0)
            return new SizedBox(height: ScreenUtil.getInstance().setHeight(0.0));

          return new Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0),
              child: Column(
                children: <Widget>[
                  new NoPostsCard(),
                ],
              )
          );
        },
      );
    } else {

      return ListView.separated(
        addAutomaticKeepAlives: false,
        itemCount: posts.length + 1,
        separatorBuilder: (_, index) {
          if (index == 0)
            // change post form to user card
            return new Padding(
                padding: EdgeInsets.only(left: 28.0, right: 28.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                        height: ScreenUtil.getInstance().setHeight(10.0)
                    ),
                    postForm(),
                  ],
                )
            );

          return new SizedBox(height: ScreenUtil.getInstance().setHeight(0.0));
        },
        itemBuilder: (_, index) {
          if (index == 0)
            return new SizedBox(height: ScreenUtil.getInstance().setHeight(0.0));

          return new Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                      height: ScreenUtil.getInstance().setHeight(20.0)
                  ),
                  horizontalLine(),
                  SizedBox(
                      height: ScreenUtil.getInstance().setHeight(20.0)
                  ),
                  new PostCard(posts[index - 1], userModel),
                  (index == posts.length ?
                  SizedBox(
                      height: ScreenUtil.getInstance().setHeight(20.0)
                  ) :
                  SizedBox(
                      height: ScreenUtil.getInstance().setHeight(0.0)
                  ))
                ],
              )
          );
        },
      );
    }
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
            Column(
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
                              image: new NetworkImage(userModel.profilePictureUrl.isNotEmpty ?
                              userModel.profilePictureUrl :
                              'https://i.nonevale.me/x5q13ki8.png')
                          )
                      ),
                    ),
                    SizedBox(width: ScreenUtil.getInstance().setWidth(16)),
                    Text("Status",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins-Medium",
                            fontSize: ScreenUtil.getInstance().setSp(32),
                            letterSpacing: 0.1)
                    ),
                    Spacer(),
                    InkWell(
                      child: Container(
                        width: ScreenUtil.getInstance().setWidth(126),
                        height: ScreenUtil.getInstance().setHeight(48),
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
                                      fontSize: ScreenUtil.getInstance().setSp(28.0),
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
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
                        if (_isBlank) {
                          _toggleIsBlank(_statusController.text.isEmpty || _statusController.text.trim().isEmpty);
                        }
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "Status",
                        errorText: _isBlank ? "You may not post an empty status." : null,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)
                    ),
                  ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(40),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void checkIsBlank() {
    _toggleIsBlank(_statusController.text.isEmpty || _statusController.text.trim().isEmpty);
  }

  Future<void> post(BuildContext context) async {
    checkIsBlank();
    if (_isBlank) return;

    final postForm = new PostRegistrationModel(_statusController.text, userModel);
    String apiUrl = "http://167.114.114.217:8080/api/posts/register";
    final response = await http.post(apiUrl, body: postForm.toJson());

    if (response.statusCode == 200) {
      prefix0.Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TimelineScreen(userModel)),
      );
    }
  }
}