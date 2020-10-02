import 'package:army_chatbot/counselor.dart';
import 'package:army_chatbot/signin.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Army ChatBot',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Army ChatBot'),
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

  void _alert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("입력"),
          content: new Text("아이디 혹은 비밀번호를 입력해주세요"),
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

  void _login() {
    setState(() {
      if (idController.text == "" || passwdController.text == "") {
        _alert();
        return;
      }
      id = idController.text;
      passwd = passwdController.text;
    });
  }

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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CounSel()));
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
                          })
                    ])),
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
