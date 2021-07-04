import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_list.dart';

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
  final titleController = TextEditingController();
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
  //String cont_title = "상담 제목을 입력해주세요.";
  String contents = "상담 내용을 입력해주세요.";

  bool checked = false; // 상담 신청 동의 체크
  bool anonyCheck = false;

  bool wantClear = false;

  Future<void> _submit(String title, String email, String content,
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
      'title': title,
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
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
              child: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Text(
                  '법률 및 인권 상담 신청',
                  style: TextStyle(fontSize: 22),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(border: Border.all(width: 1)),
                child: Text(
                    ' 육군 법률 및 인권 상담 앱 "아미챗"에 등록된 상담사와의 개인 상담을 위한 페이지입니다. '
                    '익명 상담을 체크하실 경우 상담원에게 개인 정보가 드러나지 않습니다. '
                    '상담원에 대한 모욕적인 언행이나 욕설 등의 행위는 관련 법규에 의거 고발될 수 있음을 알려드립니다. '
                    '\n\n 익명 상담을 원하실 경우 반드시 "익명으로 상담하기"를 꼭 체크해주시기 바랍니다. ',
                    style: TextStyle(fontSize: 14.5)),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('위 내용을 확인하셨습니까?'),
                    Checkbox(
                      value: checked,
                      onChanged: _isChecked,
                    )
                  ],
                ),
              ),
              Divider(
                height: 80,
                color: Colors.black,
                thickness: 0.5,
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
                      onPressed: () {
                        nameController.clear();
                        wantClear = true;
                      },
                      icon: Icon(Icons.clear),
                    ),
                    border: OutlineInputBorder()),
                onTap: () {
                  if (!wantClear) {
                    nameController.text = _name;
                  }
                  wantClear = false;
                },
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
                      onPressed: () {
                        phoneController.clear();
                        wantClear = true;
                      },
                      icon: Icon(Icons.clear),
                    ),
                    border: OutlineInputBorder()),
                onTap: () {
                  if (!wantClear) {
                    phoneController.text = _phone;
                  }
                  wantClear = false;
                },
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
                      onPressed: () {
                        armyNumController.clear();
                        wantClear = true;
                      },
                      icon: Icon(Icons.clear),
                    ),
                    border: OutlineInputBorder()),
                onTap: () {
                  if (!wantClear) {
                    armyNumController.text = _armyNum;
                  }
                  wantClear = false;
                },
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
              Divider(
                height: 80,
                color: Colors.black,
                thickness: 0.5,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Center(
                    child: Text(
                  '상담 정보 입력',
                  style: TextStyle(fontSize: 22),
                )),
              ),
              TextFormField(
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  maxLength: 20,
                  //maxLines: 50,
                  decoration: InputDecoration(
                      hintText: '상담 제목을 입력해주세요',
                      suffixIcon: IconButton(
                        onPressed: () => titleController.clear(),
                        icon: Icon(Icons.clear),
                      ),
                      border: OutlineInputBorder())),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3),
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
                                      //border: OutlineInputBorder()
                                    ))),
                          ))),
                ]),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3),
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
                      onPressed: () {
                        emailController.clear();
                        wantClear = true;
                      },
                      icon: Icon(Icons.clear),
                    ),
                    border: OutlineInputBorder()),
                onTap: () {
                  if (!wantClear) {
                    emailController.text = _email;
                  }
                  wantClear = false;
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3),
              ),
              Center(
                child: ElevatedButton(
                    child: Text("신청하기"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () => {
                          _submit(
                              titleController.text,
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
              )),
    );
  }
}
