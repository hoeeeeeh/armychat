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

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Army ChatBot',
      theme: header.isDarkMode ? header.darkModeTheme : header.defaultTheme,
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
            new FlatButton(
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

  void _login([String name, String email]) {
    if (name != null && email != null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Userinfo(name, email)));
      return;
    }
    setState(() {
      if (idController.text == "admin" && passwdController.text == "admin") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Userinfo('DB에서 받아올 이름', 'backgol@naver.com')));
      } else if (idController.text == "" || passwdController.text == "") {
        _alert();
        return;
      } else {
        _alert("아이디 혹은 비밀번호가 올바르지 않습니다.");
        return;
      }

      id = idController.text;
      passwd = passwdController.text;
    });
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title ?? 'ARMY CHATBOT'),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text('육군 규정 상담 챗봇, "아미챗봇" '),
                ),
                TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter(RegExp('[a-z]'), allow: true),
                    ], // 문자만 허용
                    controller: idController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: '아이디를 입력해주세요',
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
                        suffixIcon: IconButton(
                          onPressed: () => idController.clear(),
                          icon: Icon(Icons.clear),
                        ),
                        border: OutlineInputBorder())),
                Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      RaisedButton(
                          child: Text('로그인'),
                          onPressed: () {
                            _login();
                          }),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      RaisedButton(
                          child: Text('회원가입'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn()));
                          }),
                    ])),
                Padding(padding: EdgeInsets.only(bottom: 10)),
                Center(
                  child: Column(
                    children: [
                      SignInButton(Buttons.Google, onPressed: () {
                        _handleSignIn().then((user) {
                          print(user);
                          _login(user.displayName, user.email);
                        });
                      }),
                      SignInButton(Buttons.Facebook, onPressed: () {}),
                      SignInButton(Buttons.Apple, onPressed: () {}),
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

  Future<User> _handleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    User user = (await _auth.signInWithCredential(GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken)))
        .user;
    print("signed in " + user.displayName);
    return user;
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
          return Text('what the fuck');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyHomePage(title: 'Army ChatBot');
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Text("it's too hard");
      },
    );
  }
}
