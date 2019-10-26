import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_midterm_application/post/PostModel.dart';
import 'package:fs_midterm_application/screens/UserListScreen.dart';
import 'package:fs_midterm_application/user/UserModel.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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

  var code;

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
    return userCard(context);
  }

  Future getImage() async {
    if (viewer.userId == userModel.userId) {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      Upload(image);
    }
  }

  Upload(File imageFile) async {
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    String apiUrl = "https://i.nonevale.me/up.php?secret=noneValeFileUploader431";
    var uri = Uri.parse(apiUrl);

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

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
                    getImage();
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

  Future<void> followButton(UserModel follow) async {
    String apiUrl = "http://167.114.114.217:8080/api/users/" + (follow.followers.contains(viewer.userId) ? "unfollow" : "follow") + "/" + follow.userId;
    final response = await http.post(apiUrl, body: { "userId": viewer.userId });
    follow.update().then((result) {
      setState(() {
        code = 1;
      });
    });
  }
}