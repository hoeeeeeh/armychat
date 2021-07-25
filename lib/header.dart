import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

final ThemeData kIOSTheme = ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light);

// 기본 테마
final ThemeData defaultTheme = ThemeData(
  primarySwatch: Colors.grey,
  // 전송버튼에 적용할 색상으로 이용
  accentColor: Colors.orangeAccent[400],
);

final ThemeData darkModeTheme = ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.black,
    primaryColorBrightness: Brightness.dark);

bool isDarkMode = true;

/* DB 에서 받아올 목록들 */
String userName = "이름";
String userEmail = "";
String userArmyNum = "";
String userId = 'id';
String phoneNum = '010-1234-5678';
String counselCenterName = "";
List friendList = [];
List chatList = [];
var myCounselCenter;

String indiCouncel = 'individualCouncel';

final FirebaseAuth _auth = FirebaseAuth.instance;

/*

inputFormatters: [ FilteringTextInputFormatter(RegExp('[a-z]'), allow: true),], // 문자만 허용
inputFormatters: [FilteringTextInputFormatter.digitsOnly], // 숫자만 허용

*/
