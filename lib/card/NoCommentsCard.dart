import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoCommentsCard extends StatefulWidget {

  @override
  NoCommentsCardState createState() => new NoCommentsCardState();
}

class NoCommentsCardState extends State<NoCommentsCard> {

  @override
  Widget build(BuildContext context) {
    return postCard();
  }

  Widget postCard() {
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
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    "No comments to display.",
                    style: TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil.getInstance().setSp(32)
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}