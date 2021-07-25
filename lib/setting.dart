import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'header.dart' as header;
import 'profileEditor.dart';
import 'indiCounselEditor.dart' as indi;

class Setting extends StatefulWidget {
  Setting({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  void darkMode(bool value) {
    setState(() {
      header.isDarkMode = !(header.isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
              child: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            _buildTile('프로필', Icons.person, Profile()),
            ListTile(
                title: Text('개인 상담소 개설 신청'),
                onTap: () => {
                      if (header.counselCenterName != '')
                        {_alert('이미 개인 상담소가 존재합니다')}
                      else
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IndiCounsel()))
                        }
                    },
                leading: Icon(Icons.meeting_room)),
            _buildTile(
                '내 상담소 관리', Icons.house_outlined, indi.IndiCounselEditor()),
            ListTile(
                title: Text('상담 내역 관리'),
                onTap: () =>
                    {}, //Navigator.push(context,MaterialPageRoute(builder: (context) => IndiCounsel())),
                leading: Icon(Icons.list_alt)),
            _buildTile('만든 이', Icons.people, MakingNotes()),
            // ListTile(
            //   title: Text('설정 1'),
            // ),
            ListTile(
                title: Text('로그아웃'),
                onTap: () async {
                  Navigator.pop(context);
                  //await header._auth.signOut();
                },
                leading: Icon(Icons.exit_to_app)),

            ListTile(
              title: Text(
                '앱에 관련된 문의사항은 \n hoeeeeeh@gmail.com으로 문의주세요!!',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ).toList(),
      ))),
    );
  }

  Widget _buildTile(String text, IconData icon, var route) => ListTile(
      title: Text(text),
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => route)),
      leading: Icon(icon));

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
}

class B extends StatefulWidget {
  B({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _BState createState() => _BState();
}

class _BState extends State<B> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}

class MakingNotes extends StatefulWidget {
  MakingNotes({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MakingNotesState createState() => _MakingNotesState();
}

class _MakingNotesState extends State<MakingNotes> {
  int count = 0;
  Timer _timer;

  bool _visible = true;
  String text = '개발자 : 상병 김영길 병장 노경민 등 \n 소프트웨어 동아리 Sudo \n';

  @override
  void initState() {
    super.initState();
    _start();
  }

  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void _start() {
    _timer = Timer.periodic(Duration(seconds: 7), (timer) {
      setState(() {
        if (count == 0) {
          _visible = false;
          count++;
        } else if (count == 1) {
          text =
              '소프트웨어 동아리를 위해 아낌없이 힘 써주신 \n 박필하 대대장님 && 한갑교 중사님, 진심으로 감사드립니다. \n - 소프트웨어 동아리 Sudo 일동';
          _visible = true;
          count++;
        } else if (count == 2) {
          _visible = false;
          count++;
        } else if (count == 3) {
          Navigator.pop(context);
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedOpacity(
      // If the widget is visible, animate to 0.0 (invisible).
      // If the widget is hidden, animate to 1.0 (fully visible).
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      // The green box must be a child of the AnimatedOpacity widget.
      child: Container(
          child: Center(
              child: Text(
        text ?? 'default value',
        textAlign: TextAlign.center,
      ))),
    ));
  }
}

class IndiCounsel extends StatefulWidget {
  @override
  _IndiCounselState createState() => _IndiCounselState();
}

class _IndiCounselState extends State<IndiCounsel> {
  final _data = header.counselCenterName;
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _fieldController = TextEditingController();
  final _ageController = TextEditingController();
  final _introduceController = TextEditingController();

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
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Column(children: [
                      Text('개인 상담소 개설 신청',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 10,
                      ),
                      Text('관리자 승인 이후 개설이 완료됩니다'),
                    ]),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  TextField(
                    controller: _nameController,
                    maxLength: 20,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          splashColor: Colors.transparent,
                          onPressed: () => _nameController.clear(),
                          icon: Icon(Icons.clear),
                        ),
                        filled: true,
                        fillColor: Color(0xFFe7edeb),
                        hintText: "상담소 이름",
                        prefixIcon: Icon(
                          Icons.perm_contact_cal,
                          color: Colors.grey,
                        )),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          splashColor: Colors.transparent,
                          onPressed: () => _locationController.clear(),
                          icon: Icon(Icons.clear),
                        ),
                        filled: true,
                        fillColor: Color(0xFFe7edeb),
                        hintText: "지역",
                        prefixIcon: Icon(
                          Icons.location_on,
                          color: Colors.grey,
                        )),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: _ageController,
                    inputFormatters: [
                      FilteringTextInputFormatter(RegExp('[0-9]'), allow: true),
                    ],
                    onChanged: null,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          splashColor: Colors.transparent,
                          onPressed: () => _ageController.clear(),
                          icon: Icon(Icons.clear),
                        ),
                        filled: true,
                        fillColor: Color(0xFFe7edeb),
                        hintText: "나이",
                        prefixIcon: Icon(
                          Icons.schedule,
                          color: Colors.grey,
                        )),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: _fieldController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          splashColor: Colors.transparent,
                          onPressed: () => _fieldController.clear(),
                          icon: Icon(Icons.clear),
                        ),
                        filled: true,
                        fillColor: Color(0xFFe7edeb),
                        hintText: "자신있는 분야",
                        prefixIcon: Icon(
                          Icons.cloud_queue,
                          color: Colors.grey,
                        )),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: _introduceController,
                    maxLength: 50,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          splashColor: Colors.transparent,
                          onPressed: () => _introduceController.clear(),
                          icon: Icon(Icons.clear),
                        ),
                        filled: true,
                        fillColor: Color(0xFFe7edeb),
                        hintText: "간단한 소개",
                        prefixIcon: Icon(
                          Icons.article,
                          color: Colors.grey,
                        )),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Container(
                      width: 300,
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100)),
                      child: ElevatedButton(
                          onPressed: () {
                            _confirm();
                          },
                          child: Text("신청하기",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17)),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))))),
                  SizedBox(height: 20.0),
                  Container(
                      width: 300,
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100)),
                      child: ElevatedButton(
                          onPressed: () => {Navigator.pop(context)},
                          child: Text("취 소",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17)),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))))),
                ],
              )),
        )),
      ),
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
    if (isEmpty(_nameController.text)) {
      output += '상담소 이름';
      empty = true;
    }
    if (isEmpty(_locationController.text)) {
      if (empty) output += ',';
      output += '지역';
      empty = true;
    }
    if (isEmpty(_ageController.text)) {
      if (empty) output += ',';
      output += '나이';
      empty = true;
    }
    if (isEmpty(_fieldController.text)) {
      if (empty) output += ',';
      output += '분야';
      empty = true;
    }
    if (isEmpty(_introduceController.text)) {
      if (empty) output += ',';
      output += '소개';
      empty = true;
    }
    if (empty) {
      _alert(output);
    } else {
      String time = DateTime.now().toString();
      header.myCounselCenter = {
        'age': _ageController.text,
        'field': _fieldController.text,
        'hostId': header.userId,
        'hostname': header.userName,
        'introduce': _introduceController.text,
        'location': _locationController.text,
        'phone': header.phoneNum, //사용자 계정.text,
        'title': _nameController.text,
      };
      firestore
          .collection('individualCouncel')
          .doc(time)
          .set(header.myCounselCenter);
      header.counselCenterName = time;

      firestore
          .collection('member')
          .doc(header.userId)
          .update({'counselCenterName': time});
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => indi.IndiCounselEditor()));

      //idController.text = ; 나중에 회원가입하면 자동으로 로그인 창에 아이디,비번 띄워주는 옵션
      _alert('개인 상담소 신청이 정상적으로 완료되었습니다!');
    }
  }
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String _userId = header.userId; //사용자 계정
  final String _userName = header.userName; //사용자 이름
  final String _userSerialNumber = header.userArmyNum; //사용자 군번
  final String _userEmail = header.userEmail; //이메일
  Widget _createCustomListTile(String leadingTxt, String titleTxt) {
    return ListTile(
      leading: Text(
        leadingTxt,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      trailing: Text(
        titleTxt,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.06),
        child: AppBar(
          backgroundColor: Colors.white,
          //Color(0xff1899e9)
          //backgroundColor: Colors.white,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, size: 30),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('프로필 관리',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 10,
          shadowColor: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 50, horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(children: [
                    ClipOval(
                      child: Material(
                        child: Ink.image(
                          image: NetworkImage(
                              'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'),
                          fit: BoxFit.cover,
                          width: 128,
                          height: 128,
                          child: InkWell(onTap: () {}),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 4,
                        child: ClipOval(
                            child: Container(
                                padding: EdgeInsets.all(3),
                                color: Colors.white,
                                child: ClipOval(
                                    child: Container(
                                        color: Colors.red,
                                        padding: EdgeInsets.all(8),
                                        child: Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: Colors.white,
                                        ))))))
                  ]),
                  SizedBox(height: 30),
                  Divider(),
                  _createCustomListTile('계정', '$_userId'),
                  Divider(),
                  _createCustomListTile('이름', '$_userName'),
                  Divider(),
                  _createCustomListTile('군번', '$_userSerialNumber'),
                  Divider(),
                  _createCustomListTile('이메일', '$_userEmail'),
                  Divider(),

                  /*
                  firestore.collection('member').doc(idController.text).set({
                    'id': idController.text,
                    'passwd': passwdController.text,
                    'email': emailController.text,
                    'armyNum': armyNumController.text,
                    'phoneNum': phoneController.text,
                    'name': nameController.text,
                    'counselCount': 0,
                    'chatList': [],
                  }
                  */
                  SizedBox(height: 30),
                  Container(
                      width: 300,
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100)),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileEditor()));
                          },
                          child: Text("정보수정",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17)),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


//   _timer2 = Timer.periodic(Duration(seconds: 10), (timer) {
//     setState(() {
//       text = 'Thanks To 박XX';
//       _timer2.cancel();
//       _visible = true;
//     });
//   });
// }
