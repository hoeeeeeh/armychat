import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
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
  TextEditingController idController;
  TextEditingController passwdController;
  TextEditingController emailController;
  TextEditingController nameController;
  TextEditingController phoneController;
  TextEditingController armyNumController;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String id;
  String passwd;

  bool checked;

  void initState() {
    super.initState();

    id = '아직 아이디가 입력되지 않았습니다.';
    passwd = '아직 비밀번호가 입력되지 않았습니다.';
    idController = TextEditingController();
    passwdController = TextEditingController();
    emailController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    armyNumController = TextEditingController();

    id = '아직 아이디가 입력되지 않았습니다.';
    passwd = '아직 비밀번호가 입력되지 않았습니다.';
    checked = false;
  }

  void dispose() {
    idController.dispose();
    passwdController.dispose();
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    armyNumController.dispose();
    super.dispose();
  }

  void _alert(String output) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("알림"),
          content: new Container(
            width: 200,
            height: 60,
            child: new Center(
              child: new Text(
                output ?? 'defalut value',
                textAlign: TextAlign.center,
              ),
            ),
          ),
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

  bool isEmpty(String thing) {
    if (thing == "")
      return true;
    else
      return false;
  }

  void _confirm() {
    String output = '';
    bool empty = false;
    if (!checked) {
      _alert('약관에 동의해주세요!');
      return;
    }
    if (isEmpty(idController.text)) {
      output = output + '아이디';
      empty = true;
    }
    if (isEmpty(passwdController.text)) {
      if (empty) output = output + ',';
      output = output + '비밀번호';
      empty = true;
    }
    if (isEmpty(emailController.text)) {
      if (empty) output = output + ',';
      output = output + '이메일';
      empty = true;
    }
    if (nameController.text == '') {
      if (empty) output = output + ',';
      output = output + '이름';
      empty = true;
    }
    if (phoneController.text == '') {
      if (empty) output = output + ',';
      output = output + '핸드폰';
      empty = true;
    }
    if (armyNumController.text == '') {
      if (empty) output = output + ',';
      output = output + '군번';
      empty = true;
    }
    if (empty) {
      output = output + '\n은 필수 기재 항목입니다.';
      _alert(output);
    } else {
      firestore.collection('member').doc(idController.text).set({
        'id': idController.text,
        'passwd': passwdController.text,
        'email': emailController.text,
        'armyNum': armyNumController.text,
        'phoneNum': phoneController.text,
        'name': nameController.text,
        'counselCount': 0,
        'chatList': [],
        'friendList': [],
        'counselCenterName': ''
      });
      Navigator.pop(context);
      //idController.text = ; 나중에 회원가입하면 자동으로 로그인 창에 아이디,비번 띄워주는 옵션
      _alert('정상적으로 회원가입이 되었습니다.');
    }
  }

  void _isChecked(bool value) {
    setState(() {
      checked = !checked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
          child: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
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
                height: 450,
                child: Column(children: <Widget>[
                  Container(
                      height: 400,
                      width: 400,
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      child: Container(
                          height: 450,
                          child: SingleChildScrollView(
                            child: Center(
                                child: Text(
                              '약관\n\n제 3보병사단 인권 상담소 앱 아미챗 의 약관내용입니다.\n\n잘 읽고 회원가입 해 주세요.',
                              textAlign: TextAlign.center,
                            )),
                          ))),
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('약관에 동의하십니까?'),
                        Checkbox(
                          value: checked,
                          onChanged: _isChecked,
                        )
                      ],
                    ),
                  )
                ]),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              TextFormField(
                  // id 입력
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp('[a-z,0-9]'),
                        allow: true),
                  ],
                  controller: idController,
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 15,
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
                  // passwd 입력
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp('[a-z,A-Z,0-9,!-%,@]'),
                        allow: true),
                  ],
                  controller: passwdController,
                  maxLines: 1,
                  maxLength: 15,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: '비밀번호를 입력해주세요',
                      suffixIcon: IconButton(
                        onPressed: () => passwdController.clear(),
                        icon: Icon(Icons.clear),
                      ),
                      border: OutlineInputBorder())),
              Padding(
                padding: EdgeInsets.all(1),
              ),
              TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp('[a-z,0-9,.,@,_]'),
                        allow: true),
                  ],
                  // 이메일주소 입력
                  controller: emailController,
                  maxLength: 30,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: '이메일을 입력해주세요',
                      suffixIcon: IconButton(
                        onPressed: () => emailController.clear(),
                        icon: Icon(Icons.clear),
                      ),
                      border: OutlineInputBorder())),
              Padding(
                padding: EdgeInsets.all(1),
              ),
              TextFormField(
                  // 이름
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp('[a-z,ㄱ-ㅎ|ㅏ-ㅣ|가-힣]'),
                        allow: true),
                  ],
                  maxLength: 10,
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      hintText: '이름을 입력해주세요',
                      suffixIcon: IconButton(
                        onPressed: () => nameController.clear(),
                        icon: Icon(Icons.clear),
                      ),
                      border: OutlineInputBorder())),
              Padding(
                padding: EdgeInsets.all(1),
              ),
              TextFormField(
                  // 핸드폰 번호 입력

                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp('[0-9,-]'), allow: true),
                  ],
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  maxLength: 13,
                  decoration: InputDecoration(
                      hintText: '핸드폰 번호("-" 포함)를 입력해주세요',
                      suffixIcon: IconButton(
                        onPressed: () => phoneController.clear(),
                        icon: Icon(Icons.clear),
                      ),
                      border: OutlineInputBorder())),
              Padding(
                padding: EdgeInsets.all(1),
              ),
              TextFormField(
                  // 군번 입력
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp('[0-9,-]'), allow: true),
                  ],
                  controller: armyNumController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: '군번을 입력해주세요 ("-"을 포함하고 입력해주세요.)',
                      suffixIcon: IconButton(
                        onPressed: () => armyNumController.clear(),
                        icon: Icon(Icons.clear),
                      ),
                      border: OutlineInputBorder())),
              ElevatedButton(
                child: Text('완료'),
                onPressed: _confirm,
              ),
            ],
          ),
        ),
      )
          // This trailing comma makes auto-formatting nicer for build methods.
          ),
    ));
  }
}
