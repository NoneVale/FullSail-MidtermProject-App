import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_midterm_application/post/PostModel.dart';
import 'package:fs_midterm_application/user/UserModel.dart';
import 'package:http/http.dart' as http;

class SearchBarCard extends StatefulWidget {
  TextEditingController searchBar = new TextEditingController();

  @override
  SearchBarCardState createState() => new SearchBarCardState(searchBar);
}

class SearchBarCardState extends State<SearchBarCard> {
  TextEditingController searchBar;

  SearchBarCardState(TextEditingController searchBar) {
    this.searchBar = searchBar;
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
    return userCard();
  }

  Widget userCard() {
    return new Container(
      width: double.infinity,
      height: ScreenUtil.getInstance().setHeight(400),
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
            TextField(
              maxLength: 20,
              controller: searchBar,
            )
          ],
        ),
      ),
    );
  }
}