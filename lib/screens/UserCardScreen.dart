import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_midterm_application/card/NoPostsCard.dart';
import 'package:fs_midterm_application/card/PostCard.dart';
import 'package:fs_midterm_application/post/PostModel.dart';
import 'package:fs_midterm_application/screens/NotificationsScreen.dart';
import 'package:fs_midterm_application/screens/SearchScreen.dart';
import 'package:fs_midterm_application/screens/TimelineScreen.dart';
import 'package:fs_midterm_application/user/UserModel.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'UserListScreen.dart';

class UserCardScreen extends StatefulWidget {

  UserModel userModel;
  UserModel viewer;

  UserCardScreen(UserModel userModel, UserModel viewer) {
    this.userModel = userModel;
    this.viewer = viewer;
  }

  @override
  UserCardScreenState createState() => new UserCardScreenState(userModel, viewer);
}

class UserCardScreenState extends State<UserCardScreen> {

  var _result;
  var _result2;

  var code = 0;

  bool _pickImage = false;

  var _image = null;

  UserModel userModel;
  UserModel viewer;
  List<PostModel> posts;

  UserCardScreenState(UserModel userModel, UserModel viewer) {
    this.userModel = userModel;
    this.viewer = viewer;
    posts = [];
  }

  @override
  void initState() {
    userModel.update().then((_result) {
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
        automaticallyImplyLeading: !(userModel.userId == viewer.userId),
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
          userPage(context),
          _pickImage ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Spacer(),
              imagePickerCard(),
            ],
          ) : Container(width: 0, height: 0)
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
    String apiUrl = "http://167.114.114.217:8080/api/posts/user/" + userModel.userId;
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

  Widget verticalLine() => Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: Container(
      width: ScreenUtil.getInstance().setWidth(1.0),
      height: ScreenUtil.getInstance().setHeight(48.0),
      color: Colors.black26.withOpacity(0.4),
    ),
  );

  Widget userCard(BuildContext context) {
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    userModel.username,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil.getInstance().setSp(36)
                    ),
                  ),
                  Spacer(),
                  (userModel.userId != viewer.userId ? InkWell(
                    child: Container(
                      width: ScreenUtil.getInstance().setWidth(128.0 + (userModel.followers.contains(viewer.userId) ? 16.0 : 0.0)),
                      height: ScreenUtil.getInstance().setHeight(48.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                            onTap: () {
                              followButton(userModel);
                            },
                            child: Center(
                                child: Text(userModel.followers.contains(viewer.userId) ? "Unfollow" : "Follow")
                            )
                        ),
                      ),
                    ),
                  ) : SizedBox(width: 0.0,))
                ],
              ),
            ),
            SizedBox(height: ScreenUtil.getInstance().setHeight(8.0),),
            horizontalLine(),
            SizedBox(height: ScreenUtil.getInstance().setHeight(32.0),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: (){
                    setState(() {
                      if (userModel.userId == viewer.userId) {
                        _pickImage = true;
                      }
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 64.0,
                        height: 64.0,
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
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserListScreen("Followers", userModel.followers, viewer)),
                        );
                      },
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
                    )
                ),
                verticalLine(),
                Container(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserListScreen("Following", userModel.following, viewer)),
                        );
                      },
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
                    )
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
            ),
            SizedBox(height: ScreenUtil.getInstance().setHeight(32.0),),
          ],
        ),
      ),
    );
  }

  ListView userPage(BuildContext context) {
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
                    userCard(context),
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
                    userCard(context),
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

  Future getGalleryImage() async {
    uploadProfilePicture(await ImagePicker.pickImage(source: ImageSource.gallery));

  }

  Future getCameraImage() async {
    uploadProfilePicture(await ImagePicker.pickImage(source: ImageSource.camera));
  }

  void uploadProfilePicture(File imageFile) async {
    setState(() {
      _pickImage = false;
    });

    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    String apiUrl = "http://167.114.114.217:8080/api/files/upload";
    var uri = Uri.parse(apiUrl);

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);
    var response = await request.send();

    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) async {
        apiUrl = "http://167.114.114.217:8080/api/users/profilePicture";
        print(apiUrl);
        var response2 = await http.post(apiUrl, body: { "userId": userModel.userId, "url": value });
        print(response2.statusCode);
        if (response2.statusCode == 200) {
          userModel.update().then((result) {
            setState(() {
              code++;
            });
          });
        }
      });
    }
  }

  Widget imagePickerCard() {
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
          ]
      ),
      child: Column(
        children: <Widget>[
          InkWell(
            child: Container(
              height: ScreenUtil.getInstance().setHeight(80),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.white,
                    Colors.white
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
                    getGalleryImage();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.collections, color: Color(0xFF29323c)),
                      SizedBox(
                        width: ScreenUtil.getInstance().setWidth(16.0),
                      ),
                      Text("Photo Gallery",
                          style: TextStyle(
                            color: Color(0xFF29323c),
                            fontFamily: "Poppins-Bold",
                            fontSize: ScreenUtil.getInstance().setSp(28.0),
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          horizontalLine(),
          InkWell(
            child: Container(
              height: ScreenUtil.getInstance().setHeight(80),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.white,
                    Colors.white
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
                    getCameraImage();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.camera_alt, color: Color(0xFF29323c)),
                      SizedBox(
                        width: ScreenUtil.getInstance().setWidth(16.0),
                      ),
                      Text("Camera",
                          style: TextStyle(
                            color: Color(0xFF29323c),
                            fontFamily: "Poppins-Bold",
                            fontSize: ScreenUtil.getInstance().setSp(28.0),
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          horizontalLine(),
          InkWell(
            child: Container(
              height: ScreenUtil.getInstance().setHeight(80),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.white,
                    Colors.white
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
                    setState(() {
                      _pickImage = false;
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Cancel",
                          style: TextStyle(
                            color: Color(0xFF29323c),
                            fontFamily: "Poppins-Bold",
                            fontSize: ScreenUtil.getInstance().setSp(28.0),
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> followButton(UserModel follow) async {
    String apiUrl = "http://167.114.114.217:8080/api/users/" + (follow.followers.contains(viewer.userId) ? "unfollow" : "follow") + "/" + follow.userId;
    final response = await http.post(apiUrl, body: { "userId": viewer.userId });
    follow.update().then((result) {
      setState(() {
        code++;
      });
    });
  }
}