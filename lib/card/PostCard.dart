import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_midterm_application/post/PostModel.dart';

class PostCard extends StatefulWidget {

  PostModel postModel;

  PostCard(PostModel postModel) {
    this.postModel = postModel;
  }

  @override
  PostCardState createState() => new PostCardState(postModel);
}

class PostCardState extends State<PostCard> {

  PostModel postModel;

  PostCardState(PostModel postModel) {
    this.postModel = postModel;
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: verifyEmailForm(),
    );
  }

  Widget verifyEmailForm() {
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
                      Text(postModel.author.username,
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
            Text(postModel.body,
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