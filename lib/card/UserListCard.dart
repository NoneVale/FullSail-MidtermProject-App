import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_midterm_application/screens/UserCardScreen.dart';
import 'package:fs_midterm_application/user/UserModel.dart';
import 'package:http/http.dart' as http;

class UserListCard extends StatefulWidget {

  UserModel userModel;
  List<UserModel> users;

  UserListCard(UserModel userModel, List<UserModel> users) {
    this.userModel = userModel;
    this.users = users;
  }

  @override
  UserListCardState createState() => new UserListCardState(userModel, users);
}

class UserListCardState extends State<UserListCard> {

  int code = 0;

  UserModel userModel;
  List<UserModel> users;

  UserListCardState(UserModel userModel, List<UserModel> users) {
    this.userModel = userModel;
    this.users = users;
  }

  Widget horizontalLine() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.0),
      child: Container(
        width: ScreenUtil.getInstance().setWidth(double.infinity),
        height: ScreenUtil.getInstance().setHeight(1.0),
        color: Colors.black26.withOpacity(0.3),
      )
  );


  @override
  Widget build(BuildContext context) {
    return userListCard();
  }

  Widget userListCard() {
    return new Container(
      width: double.infinity,
      height: ScreenUtil.getInstance().setHeight((users.length) * 80.0),
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
        padding: EdgeInsets.all(0),
          child: ListView.separated(
            padding: EdgeInsets.all(0.0),
              itemBuilder: (_, index) {
                return InkWell(
                  child: Container(
                    width: ScreenUtil.getInstance().setWidth(512.0),
                    height: ScreenUtil.getInstance().setHeight(80.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserCardScreen(users[index], userModel)),
                          );                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 16.0, left: 16.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: new NetworkImage(users[index].profilePictureUrl.isNotEmpty ?
                                        users[index].profilePictureUrl :
                                        'https://i.nonevale.me/x5q13ki8.png')
                                    )
                                ),
                              ),
                              SizedBox(
                                  width: ScreenUtil.getInstance().setWidth(16.0)
                              ),
                              Text(users[index].username,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Poppins-Bold",
                                  fontSize: ScreenUtil.getInstance().setSp(24),
                                ),
                              ),
                              Spacer(),
                              (userModel.userId != users[index].userId ? InkWell(
                                child: Container(
                                  width: ScreenUtil.getInstance().setWidth(128.0 + (users[index].followers.contains(userModel.userId) ? 32.0 : 0.0)),
                                  height: ScreenUtil.getInstance().setHeight(48.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () {
                                          followButton(users[index]);
                                        },
                                        child: Center(
                                            child: Text(users[index].followers.contains(userModel.userId) ? "Unfollow" : "Follow")
                                        )
                                    ),
                                  ),
                                ),
                              ) : SizedBox(width: 0.0,))
                            ],
                          ),
                        )
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) {
                return horizontalLine();
              },
              itemCount: users.length
          )
      )
    );
  }

  Future<void> followButton(UserModel follow) async {
    String apiUrl = "http://167.114.114.217:8080/api/users/" + (follow.followers.contains(userModel.userId) ? "unfollow" : "follow") + "/" + follow.userId;
    final response = await http.post(apiUrl, body: { "userId": userModel.userId });
    follow.update().then((result) {
      setState(() {
        code = 1;
      });
    });
  }
}