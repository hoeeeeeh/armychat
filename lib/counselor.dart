import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class CounSel extends StatefulWidget {
  //CounSel({Key key, this.title}) : super(key: key);
  //final String title;
  CounSel(this.id);
  final String id;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _CounSelState createState() => _CounSelState(id);
}

class _CounSelState extends State<CounSel> {
  final textController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final armyNumController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String id;
  String _email;
  String _name;
  String _phone;
  String _armyNum;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final temp = await firestore.collection("member").doc(id).get();
    _email = temp.data()['email'];
    _phone = temp.data()['phoneNum'];
    _armyNum = temp.data()['armyNum'];
    _name = temp.data()['name'];
  }

  @override
  void dispose() {
    super.dispose();
  }

  _CounSelState(this.id);
  String contents = "상담 내용을 입력해주세요.";

  bool checked = false; // 상담 신청 동의 체크
  bool anonyCheck = false;

  Future<void> _submit(String email, String content,
      [String name, String phoneNum, String armyNum]) async {
    print('id : $id');
    print(name);
    final temp = await firestore.collection("member").doc(id).get();
    int counselCount = temp.data()['counselCount'] ?? 0;
    counselCount++;

    String str = 'counsel#($counselCount)';
    await firestore
        .collection("member")
        .doc(id)
        .collection("counsel")
        .doc(str)
        .set({
      'content': content,
      'email': email,
      'name': name != "" ? name : 'anonymous',
      'phoneNum': phoneNum != "" ? phoneNum : 'anonymous',
      'armyNum': armyNum != "" ? armyNum : 'anonymous',
    });

    _alert('상담 접수가 완료되었습니다.');
    firestore
        .collection('member')
        .doc(id)
        .update({'counselCount': counselCount});
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

  void isEmpty(bool checked) {
    setState(() {
      checked = !checked;
    });
  }

  void _isChecked(bool value) {
    setState(() {
      checked = !checked;
    });
  }

  void setAnonymous(bool value) {
    setState(() {
      anonyCheck = !anonyCheck;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('육군 법률 상담소'),
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
                  child: Text('법률 상담'),
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
                                  child: TextFormField(
                                      // id 입력

                                      textAlign: TextAlign.center,
                                      controller: textController,
                                      keyboardType: TextInputType.text,
                                      //maxLength: 1000,
                                      maxLines: 50,
                                      decoration: InputDecoration(
                                          hintText: '상담내용을 입력해주세요',
                                          // suffixIcon: IconButton(
                                          //   onPressed: () =>
                                          //       idController.clear(),
                                          //   icon: Icon(Icons.clear),
                                          // ),
                                          border: OutlineInputBorder()))),
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
                  // 이메일주소 입력
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp('[a-z,0-9,.,@,_]'),
                        allow: true),
                  ],
                  controller: emailController,
                  maxLength: 30,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: '답변을 받을 이메일을 입력해주세요',
                      suffixIcon: IconButton(
                        onPressed: () => emailController.clear(),
                        icon: Icon(Icons.clear),
                      ),
                      border: OutlineInputBorder()),
                  onTap: () => {emailController.text = _email},
                ),

                Padding(
                  padding: EdgeInsets.all(3),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('익명으로 상담하기'),
                    Center(
                        child: Checkbox(
                      onChanged: setAnonymous,
                      value: anonyCheck,
                    )),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.all(10),
                ),

                TextFormField(
                  // 이름
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp('[a-z,ㄱ-ㅎ|ㅏ-ㅣ|가-힣]'),
                        allow: true),
                  ],
                  enabled: !anonyCheck,
                  maxLength: 10,
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      hintText: '이름을 입력해주세요',
                      suffixIcon: IconButton(
                        onPressed: () => nameController.clear(),
                        icon: Icon(Icons.clear),
                      ),
                      border: OutlineInputBorder()),
                  onTap: () => {nameController.text = _name},
                ),
                Padding(
                  padding: EdgeInsets.all(1),
                ),
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp('[0-9,-]'), allow: true),
                  ],
                  // 핸드폰 번호 입력
                  enabled: !anonyCheck,
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  maxLength: 13,
                  decoration: InputDecoration(
                      hintText: '핸드폰 번호("-" 포함)를 입력해주세요',
                      suffixIcon: IconButton(
                        onPressed: () => phoneController.clear(),
                        icon: Icon(Icons.clear),
                      ),
                      border: OutlineInputBorder()),
                  onTap: () => {phoneController.text = _phone},
                ),
                Padding(
                  padding: EdgeInsets.all(1),
                ),
                TextFormField(
                  // 군번 입력
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp('[0-9,-]'), allow: true),
                  ],
                  enabled: !anonyCheck,
                  controller: armyNumController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: '군번을 입력해주세요 ("-"을 포함하고 입력해주세요.)',
                      suffixIcon: IconButton(
                        onPressed: () => armyNumController.clear(),
                        icon: Icon(Icons.clear),
                      ),
                      border: OutlineInputBorder()),
                  onTap: () => {armyNumController.text = _armyNum},
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Text(
                  '익명으로 상담해도 로그 기록은 남으니,\n상담관님께 폭언,욕설은 자제해주시길 바랍니다.',
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                Center(
                  child: RaisedButton(
                      child: Text("접수하기"),
                      onPressed: () => {
                            _submit(
                                emailController.text,
                                textController.text,
                                nameController.text,
                                phoneController.text,
                                armyNumController.text),
                            textController.clear(),
                            emailController.clear(),
                            nameController.clear(),
                            phoneController.clear(),
                            armyNumController.clear(),
                          }),
                ),

                //Text('Your PW: $passwd'),
              ],
            ),
          ),
        )
            // This trailing comma makes auto-formatting nicer for build methods.
            ));
  }
}
