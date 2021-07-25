//import 'dart:html';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'header.dart' as header;
import 'package:army_chatbot/signin.dart';
import 'package:army_chatbot/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Army ChatBot',
      theme: !header.isDarkMode ? header.darkModeTheme : header.defaultTheme,
      home: FirebaseInit(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final idController = TextEditingController();
  final passwdController = TextEditingController();

  String id = '아직 아이디가 입력되지 않았습니다.';
  String passwd = '아직 비밀번호가 입력되지 않았습니다.';

  Future<User> _handleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    User user = (await _auth.signInWithCredential(GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken)))
        .user;
    print("signed in " + user.displayName);
    return user;
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  _signOut() async {
    await _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    idController.dispose();
    passwdController.dispose();
  }

  Widget makeText(String title, {double width, double height}) {
    return Container(
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 23.0),
        ),
      ),
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.red[300]),
    );
  }

  void _alert([String text]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialogs
        return AlertDialog(
          title: new Text("입력"),
          content: new Text(text ?? "아이디 혹은 비밀번호를 입력해주세요"),
          actions: <Widget>[
            new TextButton(
              child: new Text("닫기"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _login([String id, String pw]) {
    Future<void> firebaseIDconfirm() async {
      print(id);
      print(pw);

      /* 테스트용!! */

      //id = 'admin';
      //pw = 'admin';

      final snapShot = await firestore.collection("member").doc(id).get();
      if (snapShot.exists) {
        var user = snapShot.data();
        if (user['passwd'] == pw) {
          header.userArmyNum = user['armyNum'];
          header.userEmail = user['email'];
          header.userName = user['name'];
          header.userId = user['id'];
          header.phoneNum = user['phoneNum'];
          header.chatList = user['chatList'];
          header.counselCenterName = user['counselCenterName'] ?? '';
          header.friendList = user['friendList'] ?? '';

          if (header.counselCenterName != '') {
            await firestore
                .collection('individualCouncel')
                .doc(header.counselCenterName)
                .get()
                .then((data) {
              header.myCounselCenter = data.data();
            });
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Userinfo(user['name'], user['email'], id)));
        }
      } else {
        _alert('아이디 혹은 비밀번호를 확인해주십시오.');
      }
    }

    firebaseIDconfirm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomPadding: false,
        body: Center(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text('3'),
            ),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                        text: '육군 법률&인권 상담소, ', style: TextStyle(fontSize: 21)),
                    TextSpan(
                        text: '아미챗',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter(RegExp('[a-z,0-9]'), allow: true),
                ], // 문자만 허용
                controller: idController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: '아이디를 입력해주세요',
                    prefixIcon: Icon(Icons.person),
                    suffixIcon: IconButton(
                      onPressed: () => idController.clear(),
                      icon: Icon(Icons.clear),
                    ),
                    border: OutlineInputBorder())),
            Padding(
              padding: EdgeInsets.all(1),
            ),
            TextFormField(
                controller: passwdController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: '비밀번호를 입력해주세요',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () => idController.clear(),
                      icon: Icon(Icons.clear),
                    ),
                    border: OutlineInputBorder())),
            Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  ElevatedButton(
                      child: Text('로그인'),
                      onPressed: () {
                        _login(idController.text, passwdController.text);
                      }),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                  ElevatedButton(
                      child: Text('회원가입'),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                      }),
                ])),
            Padding(padding: EdgeInsets.only(bottom: 20)),

            Container(
              height: 30,
              //color: Colors.black,
              child: Stack(
                children: [
                  Positioned(
                    top: 15,
                    left: 0,
                    right: 230,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      alignment: Alignment.topCenter,
                      height: 1.0,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.black, width: 1))),
                    ),
                  ),
                  Positioned(
                      top: 0,
                      bottom: 1,
                      left: 140,
                      right: 140,
                      child: Container(
                        child: Text(
                          '또는',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25, fontFamily: 'GamjaFlower'),
                        ),
                      )),
                  Positioned(
                    top: 15,
                    left: 230,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      alignment: Alignment.topCenter,
                      height: 1.0,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.black, width: 1))),
                    ),
                  ),
                ],
              ),
            ),

            Padding(padding: EdgeInsets.only(bottom: 20)),
            Center(
              child: Column(
                children: [
                  SignInButton(Buttons.Google, onPressed: () {
                    _handleSignIn().then((user) {
                      print(user);
                      _login(user.displayName, user.email);
                    });
                  }),
                  SignInButton(Buttons.Facebook, onPressed: () {
                    _signOut();
                  }),
                  // SignInButton(Buttons.Apple, onPressed: () {}),
                ],
              ),
            )
            //Text('Your ID: $id'),
            //Text('Your PW: $passwd'),
          ],
        ),
      ),
    )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class FirebaseInit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text('에러가 발생했습니다. 관리자(hoeeeeeh@naver.com)에게 문의해주세요.');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyHomePage(title: '아미챗');
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return LoadingFlipping.circle();
      },
    );
  }
}
