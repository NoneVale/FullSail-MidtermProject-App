import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_midterm_application/user/UserModel.dart';

class PostPostCard extends StatefulWidget {

  UserModel userModel;

  PostPostCard(UserModel userModel) {
    this.userModel = userModel;
  }

  @override
  PostPostCardState createState() => new PostPostCardState(userModel);
}

class PostPostCardState extends State<PostPostCard> {

  UserModel userModel;

  PostPostCardState(UserModel userModel) {
    this.userModel = userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: postForm(),
    );
  }

  var _statusController = new TextEditingController();

  Widget postForm() {
    return new Container(
      width: double.infinity,
      height: ScreenUtil.getInstance().setHeight(350),
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
            Row(
              children: <Widget>[
                InkWell(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 35.0,
                        height: 35.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                //image: new NetworkImage('https://i.imgur.com/p2POb9F.jpg')
                                image: new NetworkImage('https://i.imgur.com/eFp3FH1.png')
                            )
                        ),
                      ),
                      SizedBox(width: ScreenUtil.getInstance().setWidth(10)),
                      Text("",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins-Medium",
                              fontSize: ScreenUtil.getInstance().setSp(30),
                              letterSpacing: 0.2)
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(15),
            ),
            Text("",
                maxLines: 50,
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil.getInstance().setSp(24))),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(40),
            ),
          ],
        ),
      ),
    );
  }
}