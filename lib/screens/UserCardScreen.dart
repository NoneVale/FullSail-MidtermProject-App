import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_midterm_application/card/NoPostsCard.dart';
import 'package:fs_midterm_application/card/PostCard.dart';
import 'package:fs_midterm_application/card/UserCard.dart';
import 'package:fs_midterm_application/post/PostModel.dart';
import 'package:fs_midterm_application/screens/NotificationsScreen.dart';
import 'package:fs_midterm_application/screens/SearchScreen.dart';
import 'package:fs_midterm_application/screens/TimelineScreen.dart';
import 'package:fs_midterm_application/user/UserModel.dart';
import 'package:http/http.dart' as http;

class UserCardScreen extends StatefulWidget {

  UserModel targetUser;
  UserModel viewer;

  UserCardScreen(UserModel targetUser, UserModel viewer) {
    this.targetUser = targetUser;
    this.viewer = viewer;
  }

  @override
  UserCardScreenState createState() => new UserCardScreenState(targetUser, viewer);
}

class UserCardScreenState extends State<UserCardScreen> {

  var _result;
  var _result2;

  UserModel targetUser;
  UserModel viewer;
  List<PostModel> posts;

  UserCardScreenState(UserModel targetUser, UserModel viewer) {
    this.targetUser = targetUser;
    this.viewer = viewer;
    posts = [];
  }

  @override
  void initState() {
    targetUser.update().then((_result) {
      setState(() {
        _result2 = "done";
      });
    });

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

    if (_result == null || _result2 == null) {
      return new Container();
    }

    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      appBar: new AppBar(
        automaticallyImplyLeading: !(targetUser.userId == viewer.userId),
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
          userPage(),
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
        currentIndex: 3,
        selectedItemColor: Colors.blueAccent,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimelineScreen(viewer)),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen(viewer)),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen(viewer)),
              );
              break;
          }
        },
      ),
    );
  }

  Future<void> getPosts() async {
    String apiUrl = "http://167.114.114.217:8080/api/posts/user/" + targetUser.userId;
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
            new PostCard(posts[index], viewer),
            SizedBox(height: ScreenUtil.getInstance().setHeight(20.0),)
          ],
        );
      },
    );
  }

  ListView userPage() {
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
                    new UserCard(targetUser, viewer, posts),
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
            return new SizedBox(
                height: ScreenUtil.getInstance().setHeight(0.0));

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
                    new UserCard(targetUser, viewer, posts),
                  ],
                )
            );

          return new SizedBox(height: ScreenUtil.getInstance().setHeight(0.0));
        },
        itemBuilder: (_, index) {
          if (index == 0)
            return new SizedBox(
                height: ScreenUtil.getInstance().setHeight(0.0));

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
                  new PostCard(posts[index - 1], viewer),
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
}