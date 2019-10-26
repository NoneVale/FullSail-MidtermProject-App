import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_midterm_application/card/CommentListCard.dart';
import 'package:fs_midterm_application/card/PostCard.dart';
import 'package:fs_midterm_application/post/PostModel.dart';
import 'package:fs_midterm_application/post/comment/CommentRegistrationModel.dart';
import 'package:fs_midterm_application/screens/NotificationsScreen.dart';
import 'package:fs_midterm_application/screens/TimelineScreen.dart';
import 'package:fs_midterm_application/screens/UserCardScreen.dart';
import 'package:fs_midterm_application/user/UserModel.dart';
import 'package:http/http.dart' as http;

class PostCardScreen extends StatefulWidget {

  PostModel postModel;
  UserModel userModel;

  PostCardScreen(PostModel postModel, UserModel userModel) {
    this.postModel = postModel;
    this.userModel = userModel;
  }

  @override
  PostCardScreenState createState() => new PostCardScreenState(postModel, userModel);
}

class PostCardScreenState extends State<PostCardScreen> {

  var _result;

  PostModel postModel;
  UserModel userModel;

  PostCardScreenState(PostModel postModel, UserModel userModel) {
    this.postModel = postModel;
    this.userModel = userModel;
  }

  Widget horizontalLine() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        height: ScreenUtil.getInstance().setHeight(1.0),
        color: Colors.black26.withOpacity(0.4),
      )
  );

  CommentListCard commentListCard;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 720, height: 1280, allowFontScaling: true);

    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      appBar: new AppBar(
        automaticallyImplyLeading: true,
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
          postCardContents(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Spacer(),
              postForm(),
            ],
          )
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
        selectedItemColor: Colors.blueAccent,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimelineScreen(userModel)),
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

  Widget postCardContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 28.0, right: 28.0),
        child: Column(
          children: <Widget>[
            SizedBox(
                height: ScreenUtil.getInstance().setHeight(10.0)
            ),
            PostCard(this.postModel, this.userModel),
            SizedBox(
                height: ScreenUtil.getInstance().setHeight(20.0)
            ),
            horizontalLine(),
            SizedBox(
                height: ScreenUtil.getInstance().setHeight(20.0)
            ),
            CommentListCard(this.postModel, this.userModel),
            SizedBox(
                height: ScreenUtil.getInstance().setHeight(20.0)
            ),
            //horizontalLine(),
            SizedBox(
                height: ScreenUtil.getInstance().setHeight(20.0)
            ),
          ],
        ),
      ),
    );
  }

  var _commentController = new TextEditingController();

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
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(16),
                ),
                Row(
                  children: <Widget>[

                    Flexible(
                      child: TextField(
                        controller: _commentController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        onChanged: (text) {
                          setState(() {
                            if (_isBlank) {
                              _toggleIsBlank(_commentController.text.isEmpty || _commentController.text.trim().isEmpty);
                            }
                          });
                        },
                        decoration: InputDecoration(
                            hintText: "Comment",
                            errorText: _isBlank ? "You may not post an empty status." : null,
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)
                        ),
                      )
                    ),
                    SizedBox(
                      width: ScreenUtil.getInstance().setWidth(32.0),
                    ),
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
                              child: Text("Send",
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
    _toggleIsBlank(_commentController.text.isEmpty || _commentController.text.trim().isEmpty);
  }

  Future<void> post(BuildContext context) async {
    checkIsBlank();
    if (_isBlank) return;

    final commentForm = new CommentRegistrationModel(_commentController.text, userModel, postModel);
    String apiUrl = "http://167.114.114.217:8080/api/comments/register";
    final response = await http.post(apiUrl, body: commentForm.toJson());

    if (response.statusCode == 200) {
      setState(() {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostCardScreen(postModel, userModel)),
        );
      });
    }
  }
}