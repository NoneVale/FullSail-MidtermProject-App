import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_midterm_application/screens/TimelineScreen.dart';
import 'package:fs_midterm_application/user/UserModel.dart';
import 'package:http/http.dart' as http;
import 'RegistrationScreen.dart';
import 'ForgotPasswordScreen.dart';
import 'VerifyEmailScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  bool _passwordIncorrect = false;
  bool _usernameIncorrect = false;

  final _passwordController = new TextEditingController();
  final _usernameController = new TextEditingController();

  bool _isSelected = false;

  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  void _enableUsernameError() {
    setState(() {
      _usernameIncorrect = true;
    });
  }

  void _disableUsernameError() {
    setState(() {
      _usernameIncorrect = false;
    });
  }

  void _enablePasswordError() {
    setState(() {
      _passwordIncorrect = true;
    });
  }

  void _disablePasswordError() {
    setState(() {
      _passwordIncorrect = false;
    });
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
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/invis.png", width: ScreenUtil.getInstance().setWidth(128), height: ScreenUtil.getInstance().setHeight(128),
                      ),
                      Text("",
                          style: TextStyle(
                              fontFamily: "Poppins-Bold",
                              fontSize: ScreenUtil.getInstance().setSp(46),
                              letterSpacing: .6,
                              fontWeight: FontWeight.bold))

                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(160),
                  ),
                  loginForm(),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: ScreenUtil.getInstance().setWidth(330),
                          height: ScreenUtil.getInstance().setHeight(100),
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
                                login(context);
                              },
                              child: Center(
                                child: Text("Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins-Bold",
                                        fontSize: 18,
                                        letterSpacing: 1.0)),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      horizontalLine(),
                      Text("            " , // Social Login
                          style: TextStyle(
                              fontSize: 16.0, fontFamily: "Poppins-Medium")),
                      horizontalLine()
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight((_passwordIncorrect || _usernameIncorrect) ? 50 : 90),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "New User? ",
                        style: TextStyle(fontFamily: "Poppins-Medium"),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegistrationScreen()),
                          );
                        },
                        child: Text("Register",
                            style: TextStyle(
                                color: Colors.blue,
                                fontFamily: "Poppins-Bold")),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget loginForm() {
    return new Container(
      width: double.infinity,
      height: ScreenUtil.getInstance().setHeight((_usernameIncorrect || _passwordIncorrect) ? 540 : 500),
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
            Text("Login",
                style: TextStyle(
                    fontSize: ScreenUtil.getInstance().setSp(45),
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins-Bold",
                    letterSpacing: .6)),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text("Username",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil.getInstance().setSp(26))),
            TextField(
              controller: _usernameController,

              decoration: InputDecoration(
                  hintText: "Username",
                  errorText: _usernameIncorrect ? "Invalid Username" : null,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text("Password",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil.getInstance().setSp(26))),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "Password",
                  errorText: _passwordIncorrect ? "Invalid Password" : null,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(40),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 12.0,
                    ),
                    GestureDetector(
                      onTap: _radio,
                      child: radioButton(_isSelected),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text("Remember Me",
                        style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(20), fontFamily: "Poppins-Medium", color: Colors.grey))
                  ],
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                        );
                      },
                      child: Text("Forgot Password?",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: ScreenUtil.getInstance().setSp(20),
                              fontFamily: "Poppins-Medium")),
                    ),
                    SizedBox(
                      width: 12.0,
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget radioButton(bool isSelected) => Container(
    width: 16.0,
    height: 16.0,
    padding: EdgeInsets.all(2.0),
    decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(width: 2.0, color: Colors.grey)),
    child: isSelected
        ? Container(
      width: double.infinity,
      height: double.infinity,
      decoration:
      BoxDecoration(shape: BoxShape.rectangle, color: Colors.grey),
    )
        : Container(),
  );

  Future<bool> login(BuildContext context) async {
    _disableUsernameError();
    _disablePasswordError();

    String apiUrl = "http://167.114.114.217:8080/";
    String queryUrl = apiUrl + "users/" + _usernameController.text.substring(0, 1) + "/" + _usernameController.text + ":-:" + _passwordController.text;

    var usernameResponse = await http.get(apiUrl + "username-lookup/" + _usernameController.text);
    if (usernameResponse.statusCode == 200 && usernameResponse.body.isNotEmpty) {
      if (usernameResponse.body != "true") {
        _enableUsernameError();
        return false;
      } else {
        var passwordResponse = await http.get(queryUrl);
        if (passwordResponse.statusCode == 200 && passwordResponse.body.isNotEmpty) {
          print(passwordResponse.body);
          var jsonString = json.decode(passwordResponse.body);
          UserModel userModel = UserModel.fromJson(jsonString);
          if (userModel.verified) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TimelineScreen(userModel)),
            );
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VerifyEmailScreen()),
            );
          }
          return true;
        } else if (passwordResponse.statusCode == 500) {
          _enablePasswordError();
          return false;
        }
      }
    }
    return false;
  }
}