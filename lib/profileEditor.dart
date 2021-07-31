import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'header.dart' as header;
import 'setting.dart';
import 'user.dart';

class ProfileEditor extends StatefulWidget {
  @override
  _ProfileEditorState createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditor> {
  TextEditingController _passwdController = TextEditingController();
  TextEditingController _passwdCofirmController = TextEditingController();
  TextEditingController _armyNumController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  final String _userId = header.userId; //사용자 계정
  final String _userName = header.userName; //사용자 이름
  final String _userSerialNumber = header.userArmyNum; //사용자 군번
  final String _userEmail = header.userEmail; //이메일
  final String _userPhone = header.phoneNum;
  void initState() {
    super.initState();
    _passwdController = TextEditingController();
    _passwdCofirmController = TextEditingController();
    _armyNumController = TextEditingController();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();

    _armyNumController.text = _userSerialNumber;
    _emailController.text = _userEmail;
    _nameController.text = _userName;
    _phoneController.text = _userPhone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30, horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      '프로필 정보 수정',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildCustomTextField(
                      '비밀번호', _passwdController, TextInputType.text),
                  _buildCustomTextField(
                      '비밀번호 확인', _passwdCofirmController, TextInputType.text),
                  _buildCustomTextField('군번', _armyNumController,
                      TextInputType.numberWithOptions()),
                  _buildCustomTextField(
                      '이메일', _emailController, TextInputType.emailAddress),
                  _buildCustomTextField(
                      '이름', _nameController, TextInputType.name),
                  _buildCustomTextField('휴대폰 번호', _phoneController,
                      TextInputType.numberWithOptions()),
                  SizedBox(height: 30),
                  Container(
                    width: 300,
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(100)),
                    child: ElevatedButton(
                        onPressed: () {
                          _confirm();
                        },
                        child: Text("확인",
                            style:
                                TextStyle(color: Colors.white, fontSize: 17)),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)))),
                  ),
                  SizedBox(height: 15),
                  Container(
                      width: 300,
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100)),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("취소",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17)),
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xff909090),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)))))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }

  Widget _buildCustomTextField(
      String title, TextEditingController controller, dynamic textInputType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(5, 15, 0, 0),
            child: _buildText(title)),
        TextField(
          controller: controller,
          keyboardType: textInputType,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
          ),
        ),
      ],
    );
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isEmpty(String thing) {
    if (thing == "" || thing == " ")
      return true;
    else
      return false;
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

  void _confirm() {
    String output = '다음은 필수 기재 항목입니다.\n';
    bool empty = false;
    if (isEmpty(_passwdController.text)) {
      output += '비밀번호';
      empty = true;
    }
    if (isEmpty(_passwdCofirmController.text)) {
      if (empty) output += ',';
      output += '비밀번호 확인';
      empty = true;
    } else {
      if (_passwdController.text != _passwdCofirmController.text) {
        output = '비밀번호가 다릅니다';
        _alert(output);
        return;
      }
    }

    if (isEmpty(_armyNumController.text)) {
      if (empty) output += ',';
      output += '군번';
      empty = true;
    }
    if (isEmpty(_emailController.text)) {
      if (empty) output += ',';
      output += '이메일';
      empty = true;
    }
    if (isEmpty(_nameController.text)) {
      if (empty) output += ',';
      output += '이름';
      empty = true;
    }
    if (isEmpty(_phoneController.text)) {
      if (empty) output += ',';
      output += '휴대폰 번호';
      empty = true;
    }
    if (empty) {
      _alert(output);
    } else {
      firestore.collection('member').doc(_userId).update({
        'passwd': _passwdController.text,
        'armyNum': _armyNumController.text,
        'email': _emailController.text,
        'phoneNum': _phoneController.text,
        'name': _nameController.text
      });

      firestore.collection("member").doc(_userId).get().then((user) {
        print(user);
        if (user.exists) {
          header.userArmyNum = user.data()['armyNum'];
          header.userEmail = user.data()['email'];
          header.userName = user.data()['name'];
          header.phoneNum = user.data()['phoneNum'];
        }
      });

      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Userinfo(header.userName, header.userEmail, header.userId)));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Profile()));
      //idController.text = ; 나중에 회원가입하면 자동으로 로그인 창에 아이디,비번 띄워주는 옵션
      _alert('성공적으로 변경되었습니다!');
    }
  }
}
