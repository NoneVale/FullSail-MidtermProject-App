import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_midterm_application/card/PostCard.dart';
import 'package:fs_midterm_application/post/PostModel.dart';
import 'package:fs_midterm_application/user/UserModel.dart';
import 'LoginScreen.dart';

class TimelineScreen extends StatefulWidget {

  UserModel userModel;

  TimelineScreen(UserModel userModel) {
    this.userModel = userModel;
  }

  @override
  TimelineScreenState createState() => new TimelineScreenState(userModel);
}

class TimelineScreenState extends State<TimelineScreen> {

  UserModel userModel;
  List<PostModel> posts;

  TimelineScreenState(UserModel userModel) {
    this.userModel = userModel;

    posts = [];
    posts.add(new PostModel("This is a test post.  We are not loading posts from the database yet", 1, userModel));
    posts.add(new PostModel("This is a another test post to see it on multiple cards.", 1, userModel));
    posts.add(new PostModel("How is everyone's day today?", 1, userModel));
    posts.add(new PostModel("I cant wait to finish these cards for post that way it will look so much better!", 1, userModel));
    posts.add(new PostModel("Getting there, just be patient.", 1, userModel));
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
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 720, height: 1280, allowFontScaling: true);
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
            padding: EdgeInsets.only(top: 20.0),
            child: timelineList(context),
          )
        ],
      ),
    );
  }

  ListView timelineList(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (_, index) {
        return new PostCard(posts[index]);
      },
    );
  }
}