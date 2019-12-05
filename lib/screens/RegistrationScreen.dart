import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fs_midterm_application/screens/RegistrationCompleteScreen.dart';
import 'package:http/http.dart' as http;
import "LoginScreen.dart";
import "../user/UserRegistrationModel.dart";

class RegistrationScreen extends StatefulWidget {
  @override
  RegistrationScreenState createState() => new RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {

  bool _usernameBlank = false;
  bool _firstNameBlank = false;
  bool _lastNameBlank = false;
  bool _emailBlank = false;
  bool _passwordBlank = false;
  bool _confirmPasswordBlank = false;

  bool _usernameTaken = false;
  bool _emailTaken = false;
  bool _acceptPassword = false;
  bool _passwordsMatch = false;
  bool _acceptTOS = false;

  final _usernameController = new TextEditingController();
  final _firstNameController = new TextEditingController();
  final _lastNameController = new TextEditingController();
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final _confirmPasswordController = new TextEditingController();

  void _toggleUsernameBlank(bool val) {
    setState(() {
      _usernameBlank = val;
    });
  }

  void _toggleFirstNameBlank(bool val) {
    setState(() {
      _firstNameBlank = val;
    });
  }

  void _toggleLastNameBlank(bool val) {
    setState(() {
      _lastNameBlank = val;
    });
  }

  void _toggleEmailBlank(bool val) {
    setState(() {
      _emailBlank = val;
    });
  }

  void _togglePasswordBlank(bool val) {
    setState(() {
      _passwordBlank = val;
    });
  }

  void _toggleConfirmPasswordBlank(bool val) {
    setState(() {
      _confirmPasswordBlank = val;
    });
  }

  void _toggleUsernameTaken(bool val) {
    setState(() {
      _usernameTaken = val;
    });
  }

  void _toggleEmailTaken(bool val) {
    setState(() {
      _emailTaken = val;
    });
  }

  void _toggleAcceptPassword(bool val) {
    setState(() {
      _acceptPassword = val;
    });
  }

  void _togglePasswordsMatch(bool val) {
    setState(() {
      _passwordsMatch = val;
    });
  }

  void _toggleAcceptTOS(bool val) {
    setState(() {
      _acceptTOS = val;
    });
  }

  bool _isSelected = false;

  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
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
                                register(context);
                              },
                              child: Center(
                                child: Text("Register",
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
                    height: ScreenUtil.getInstance().setHeight(90),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Already Registered? ",
                        style: TextStyle(fontFamily: "Poppins-Medium"),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text("Login",
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

  int birthMonth = 1;
  int birthDay = 1;
  int birthYear = 2019;

  List<int> getDays() {
    switch (birthMonth) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31];
      case 2:
        return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29];
      case 4:
      case 6:
      case 9:
      case 11:
        return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30];
    }
    return [1];
  }

  List<int> getYears() {
    return [
      2019, 2018, 2017, 2016, 2015, 2014, 2014, 2012, 2011, 2010, 2009, 2008, 2007, 2006, 2005, 2004, 2003, 2002, 2001,
      2000, 1999, 1998, 1997, 1996, 1995, 1994, 1993, 1992, 1991, 1990, 1989, 1988, 1987, 1986, 1985, 1984, 1983, 1982, 1981,
      1980, 1979, 1978, 1977, 1976, 1975, 1974, 1973, 1972, 1971, 1970, 1969, 1968, 1967, 1966, 1965, 1964, 1963, 1962, 1961,
      1960, 1959, 1958, 1957, 1956, 1955, 1954, 1953, 1952, 1951, 1950, 1949, 1948, 1947, 1946, 1945, 1944, 1943, 1942, 1941,
      1940, 1939, 1938, 1937, 1936, 1935, 1934, 1933, 1932, 1931, 1930, 1929, 1928, 1927, 1926, 1925, 1924, 1923, 1922, 1921,
      1920, 1919, 1918, 1917, 1916, 1915, 1914, 1913, 1912, 1911, 1910, 1909, 1908, 1907, 1906, 1905, 1904, 1903, 1902, 1901, 1900];
  }


  Widget loginForm() {
    return new Container(
      width: double.infinity,
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
            Text("Register",
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
              onChanged: (_) {
                checkUsername();
              },
              decoration: InputDecoration(
                  hintText: "Username",
                  errorText: _usernameTaken ? "That Username is already taken" : (_usernameBlank ? "This field may not be left blank" : null),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text("First Name",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil.getInstance().setSp(26))),
            TextField(
              controller: _firstNameController,
              onChanged: (_) {
                checkFirstName();
              },
              decoration: InputDecoration(
                  hintText: "First Name",
                  errorText: _firstNameBlank ? "This field may not be left blank" : null,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text("Last Name",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil.getInstance().setSp(26))),
            TextField(
              controller: _lastNameController,
              onChanged: (_) {
                checkLastName();
              },
              decoration: InputDecoration(
                  hintText: "Last Name",
                  errorText: _lastNameBlank ? "This field may not be left blank" : null,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text("Email",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil.getInstance().setSp(26))),
            TextField(
              controller: _emailController,
              onChanged: (_) {
                checkEmail();
              },
              decoration: InputDecoration(
                  hintText: "Email",
                  errorText:  _emailTaken ? "That email is already being used by another account" : (_emailBlank ? "This field may not be left blank" : null),
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
              onChanged: (_) {
                checkPassword();
              },
              decoration: InputDecoration(
                  hintText: "Password",
                  errorText: _passwordBlank ? "This field may not be left blank" : _acceptPassword ? "Requirements: Minimum of 8 characters in length \nContain 1 of each: Uppercase, Lowercase, and Number" : null,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text("Confirm Password",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil.getInstance().setSp(26))),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              onChanged: (_) {
                checkConfirmPassword();
              },
              decoration: InputDecoration(
                  hintText: "Password",
                  errorText: _confirmPasswordBlank ? "This field may not be left blank" : _passwordsMatch ? "Passwords do not match" : null,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text("Birthday",
              style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins-Medium",
              fontSize: ScreenUtil.getInstance().setSp(26))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Month"),
                    SizedBox(width: 12.0),
                    DropdownButton(value: birthMonth,
                      elevation: 16,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      underline: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      onChanged: (int newValue) {
                        setState(() {
                          birthMonth = newValue;
                          birthDay = 1;
                        });
                      },
                      items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
                    SizedBox(width: 12.0),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("Day"),
                    SizedBox(width: 12.0),
                    DropdownButton(
                      value: birthDay,
                      elevation: 16,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      underline: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      onChanged: (int newValue) {
                        setState(() {
                          birthDay = newValue;
                        });
                      },
                      items: getDays().map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
                    SizedBox(width: 12.0),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("Year"),
                    SizedBox(width: 12.0),
                    DropdownButton(
                      value: birthYear,
                      elevation: 16,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      underline: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      onChanged: (int newValue) {
                        setState(() {
                          birthYear = newValue;
                        });
                      },
                      items: getYears().map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 12.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        _radio();
                        checkTOS();
                      },
                      child: radioButton(_isSelected),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text("I accept the ",
                        style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(20), fontFamily: "Poppins-Medium", color: Colors.black)),
                    InkWell(
                      onTap: () {
                      },
                      child: Text("Terms & Conditions",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: ScreenUtil.getInstance().setSp(20),
                              fontFamily: "Poppins-Medium")),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: ScreenUtil.getInstance().setHeight(_acceptTOS ? 10.0 : 0.0)),
            (_acceptTOS ? Text("You must accept the Terms & Conditions to continue",
                style: TextStyle(
                    fontSize: ScreenUtil.getInstance().setSp(20), fontFamily: "Poppins-Medium", color: const Color(0xffD33232)))
                : SizedBox(height: ScreenUtil.getInstance().setHeight(0.0),)),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(40),
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
        border: Border.all(width: 2.0, color: _acceptTOS ? const Color(0xffD33232) : Colors.black54)),
    child: isSelected
        ? Container(
      width: double.infinity,
      height: double.infinity,
      decoration:
      BoxDecoration(shape: BoxShape.rectangle, color: Colors.black54),
    )
        : Container(),
  );

  Future<void> checkUsername() async {
    _toggleUsernameBlank(_usernameController.text.isEmpty);
    if (_usernameController.text.isEmpty) return;

    String apiUrl = "http://167.114.114.217:8080/api/users/username-lookup/" + _usernameController.text;
    var response = await http.get(apiUrl);
    if (response.statusCode == 200 &&
        response.body.isNotEmpty) {
      if (response.body == "true") {
        _toggleUsernameTaken(true);
      } else {
        _toggleUsernameTaken(false);
      }
    }
  }

  void checkFirstName() {
    _toggleFirstNameBlank(_firstNameController.text.isEmpty);
  }

  void checkLastName() {
    _toggleLastNameBlank(_lastNameController.text.isEmpty);
  }

  Future<void> checkEmail() async {
    _toggleEmailBlank(_emailController.text.isEmpty);
    if (_emailController.text.isEmpty) return;

    String apiUrl = "http://167.114.114.217:8080/api/users/email-lookup/" + _usernameController.text;

    var response = await http.get(apiUrl);
    if (response.statusCode == 200 &&
        response.body.isNotEmpty) {
      if (response.body == "true") {
        _toggleEmailTaken(true);
      } else {
        _toggleEmailTaken(false);
      }
    }
  }

  void checkPassword() {
    _togglePasswordBlank(_passwordController.text.isEmpty);
    if (_passwordController.text.isEmpty) return;

    if (_passwordController.text.contains(new RegExp(r'[A-Z]', caseSensitive: true)) && _passwordController.text.contains(new RegExp(r'[a-z]', caseSensitive: true))
        && _passwordController.text.contains(new RegExp(r'[0-9]')) && _passwordController.text.length >= 8) {
      _toggleAcceptPassword(false);
    } else {
      _toggleAcceptPassword(true);
    }
  }

  void checkConfirmPassword() {
    _toggleConfirmPasswordBlank(_confirmPasswordController.text.isEmpty);
    if (_confirmPasswordController.text.isEmpty) return;

    if (_passwordController.text == _confirmPasswordController.text) {
      _togglePasswordsMatch(false);
    } else {
      _togglePasswordsMatch(true);
    }
  }

  void checkTOS() {
    _toggleAcceptTOS(!_isSelected);
  }

  Future<void> register(BuildContext context) async {
    checkUsername();
    checkFirstName();
    checkLastName();
    checkEmail();
    checkPassword();
    checkConfirmPassword();
    checkTOS();

    if (_usernameBlank || _usernameTaken || _firstNameBlank || _lastNameBlank ||
        _emailBlank || _emailTaken || _passwordBlank || _acceptPassword ||
        _confirmPasswordBlank || _passwordsMatch || _acceptTOS) return;

    final registrationForm = UserRegistrationModel(_emailController.text, _firstNameController.text, _lastNameController.text, _usernameController.text, _passwordController.text,
        birthDay, birthMonth, birthYear);


    String apiUrl = "http://167.114.114.217:8080/api/users/register";
    final response = await http.post(apiUrl, body: registrationForm.toJson());

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegistrationCompleteScreen()),
      );
    }
  }
}