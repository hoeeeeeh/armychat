import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final idController = TextEditingController(text: '아이디를 입력해주세요');
  final passwdController = TextEditingController(text: '비밀번호를 입력해주세요');
  final emailController = TextEditingController(text: '이메일을 입력해주세요');
  final nameController = TextEditingController(text: '이름을 입력해주세요');
  final phoneController = TextEditingController(text: '핸드폰 번호를 입력해주세요');
  final armyNumController =
      TextEditingController(text: '군번을 입력해주세요 ("-"을 제외하고 입력해주세요.)');

  String id = '아직 아이디가 입력되지 않았습니다.';
  String passwd = '아직 비밀번호가 입력되지 않았습니다.';

  bool checked = false;

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

  void _confirm() {
    setState(() {
      if (idController.text == "" || passwdController.text == "") {
        _alert();
        return;
      }
      Navigator.pop(context);
    });
  }

  bool _isChecked(bool value) {
    setState(() {
      checked = !checked;
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
        body: SingleChildScrollView(
            child: Center(
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
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text('회원가입'),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                SizedBox(
                  height: 400,
                  child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                      Container(
                          height: 350,
                          width: 400,
                          decoration:
                              BoxDecoration(border: Border.all(width: 1)),
                          child: Center(
                              child: Text(
                            '약관\n약관입니다. 불만있으세요?\n약관에 불만이 있으시다면 제 알바 아닙니다.',
                            textAlign: TextAlign.center,
                          ))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('약관에 동의하십니까?'),
                          Checkbox(
                            value: checked,
                            onChanged: _isChecked,
                          )
                        ],
                      )
                    ]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                TextFormField(
                    // id 입력
                    controller: idController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(border: OutlineInputBorder())),
                Padding(
                  padding: EdgeInsets.all(1),
                ),
                TextFormField(
                    // passwd 입력
                    controller: passwdController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(border: OutlineInputBorder())),
                Padding(
                  padding: EdgeInsets.all(1),
                ),
                TextFormField(
                    // 이메일주소 입력
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(border: OutlineInputBorder())),
                Padding(
                  padding: EdgeInsets.all(1),
                ),
                TextFormField(
                    // 이름
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(border: OutlineInputBorder())),
                Padding(
                  padding: EdgeInsets.all(1),
                ),
                TextFormField(
                    // 핸드폰 번호 입력
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(border: OutlineInputBorder())),
                Padding(
                  padding: EdgeInsets.all(1),
                ),
                TextFormField(
                    // 군번 입력
                    controller: armyNumController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(border: OutlineInputBorder())),
                RaisedButton(
                  child: Text('완료'),
                  onPressed: _confirm,
                ),
                Text('Your ID: $id'),
                Text('Your PW: $passwd'),
              ],
            ),
          ),
        )
            // This trailing comma makes auto-formatting nicer for build methods.
            ));
  }
}
