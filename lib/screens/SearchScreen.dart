import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_midterm_application/card/NoPostsCard.dart';
import 'package:fs_midterm_application/card/NoResultsCard.dart';
import 'package:fs_midterm_application/card/SearchBarCard.dart';
import 'package:fs_midterm_application/card/UserListCard.dart';
import 'package:fs_midterm_application/screens/NotificationsScreen.dart';
import 'package:fs_midterm_application/screens/TimelineScreen.dart';
import 'package:fs_midterm_application/screens/UserCardScreen.dart';
import 'package:fs_midterm_application/user/UserModel.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {

  UserModel userModel;

  SearchScreen(UserModel userModel) {
    this.userModel = userModel;
  }

  @override
  SearchScreenState createState() => new SearchScreenState(userModel);
}

class SearchScreenState extends State<SearchScreen> {

  var _result = 0;

  SearchBarCard _searchBar = new SearchBarCard();

  List<UserModel> results;

  UserModel userModel;

  SearchScreenState(UserModel userModel) {
    this.userModel = userModel;
    results = [];
  }

  Widget horizontalLine() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        height: ScreenUtil.getInstance().setHeight(1.0),
        color: Colors.black26.withOpacity(0.4),
      )
  );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 720, height: 1280, allowFontScaling: true);

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
          searchPageContents()
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
        currentIndex: 1,
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

  Widget searchPageContents() {
    if (results.length == 0) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 28.0, right: 28.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                  height: ScreenUtil.getInstance().setHeight(10.0)
              ),
              searchCard(),
              SizedBox(
                  height: ScreenUtil.getInstance().setHeight(20.0)
              ),
              horizontalLine(),
              SizedBox(
                  height: ScreenUtil.getInstance().setHeight(20.0)
              ),
              new NoResultsCard(),
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
    } else {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 28.0, right: 28.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                  height: ScreenUtil.getInstance().setHeight(10.0)
              ),
              searchCard(),
              SizedBox(
                  height: ScreenUtil.getInstance().setHeight(20.0)
              ),
              horizontalLine(),
              SizedBox(
                  height: ScreenUtil.getInstance().setHeight(20.0)
              ),
              new UserListCard(this.userModel, this.results),
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
  }

  ListView searchPage() {
    if (results.length == 0) {
      return ListView.separated(
        addAutomaticKeepAlives: false,
        itemCount: results.length + 2,
        separatorBuilder: (_, index) {
          if (index == 0)
            return new Padding(
                padding: EdgeInsets.only(left: 28.0, right: 28.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                        height: ScreenUtil.getInstance().setHeight(10.0)
                    ),
                    searchCard(),
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
                  new NoResultsCard(),
                  SizedBox(
                      height: ScreenUtil.getInstance().setHeight(20.0)
                  ),
                  horizontalLine(),
                  SizedBox(
                      height: ScreenUtil.getInstance().setHeight(20.0)
                  ),
                ],
              )
          );
        },
      );
    } else {

      return ListView.separated(
        addAutomaticKeepAlives: false,
        itemCount: results.length + 1,
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
                    searchCard(),
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
                  new UserListCard(this.userModel, this.results),
                  SizedBox(
                      height: ScreenUtil.getInstance().setHeight(20.0)
                  ),
                  horizontalLine(),
                  SizedBox(
                      height: ScreenUtil.getInstance().setHeight(20.0)
                  ),
                ],
              )
          );
        },
      );
    }

  }

  TextEditingController searchBar = new TextEditingController();

  Widget searchCard() {
    return new Container(
      width: double.infinity,
      height: ScreenUtil.getInstance().setHeight(160),
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
              maxLengthEnforced: true,
              controller: searchBar,
              decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
              onChanged: (_) {
                getUsers().then((result) {
                  setState(() {
                    _result++;
                  });
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> getUsers() async {
    this.results.clear();
    String apiUrl = "http://167.114.114.217:8080/api/users/search/" + searchBar.text;
    var response = await http.get(apiUrl);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      this.results.clear();
      List<dynamic> jsonList = json.decode(response.body);
      for (dynamic dyn in jsonList) {
        UserModel user = UserModel.fromJson(dyn);
        results.add(user);
      }
    }
  }
}