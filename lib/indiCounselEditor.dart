import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'header.dart' as header;
import 'setting.dart' as prev;

class IndiCounselEditor extends StatefulWidget {
  @override
  IndiCounselEditorState createState() => IndiCounselEditorState();
}

class IndiCounselEditorState extends State<IndiCounselEditor> {
  var myData;
  bool isData;

  @override
  void initState() {
    super.initState();

    if (header.myCounselCenter != null)
      myData = header.myCounselCenter;
    else
      myData = null;
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
          title: Text('내 상담소 관리',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 10,
          shadowColor: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _createMain(myData == null)),
          ),
        ),
      ),
    );
  }

  List<Widget> _createMain(isNull) {
    if (!isNull) {
      return ([
        _createCustomListTile('상담소 이름', myData['title'] ?? ''),
        Divider(),
        _createCustomListTile('지역', myData['location'] ?? ''),
        Divider(),
        _createCustomListTile('나이', myData['age'] ?? ''),
        Divider(),
        _createCustomListTile('분야', myData['field'] ?? ''),
        Divider(),
        //_createCustomListTile('소개', data.data()['introduce'] ?? ''),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(16, 0, 0, 12),
          child: Text(
            '소개',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
          child: Text(
            ' ' + myData['introduce'],
            style: TextStyle(fontSize: 18),
          ),
        ),
        Divider(),
        SizedBox(height: 30),
        Container(
            width: 300,
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IndiCounselEditor2(myData)));
                },
                child: Text("수정",
                    style: TextStyle(color: Colors.white, fontSize: 17)),
                style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))))),
        SizedBox(height: 15),
        Container(
            width: 300,
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
            child: ElevatedButton(
                onPressed: () {
                  _deleteAlert(header.counselCenterName);
                },
                child: Text("삭제",
                    style: TextStyle(color: Colors.white, fontSize: 17)),
                style: ElevatedButton.styleFrom(
                    primary: Color(0xff909090),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))))),
      ]);
    } else {
      return ([
        SizedBox(height: MediaQuery.of(context).size.height / 4),
        Text(
          '아직 개인상담소가 없습니다',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 30),
        Container(
            width: 300,
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => prev.IndiCounsel()));
                },
                child: Text("개설하기",
                    style: TextStyle(color: Colors.white, fontSize: 17)),
                style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))))),
        SizedBox(height: 15),
      ]);
    }
  }

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

  void _deleteCouncelCenter(String name) {
    FirebaseFirestore.instance
        .collection('individualCouncel')
        .doc(name)
        .delete();
    setState(() {
      header.myCounselCenter = null;
      header.counselCenterName = '';
    });
  }

  void _deleteAlert(String name) {
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
                '정말로 삭제하시겠습니까?',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text("삭제"),
              onPressed: () {
                _deleteCouncelCenter(name);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => IndiCounselEditor()));
              },
            ),
            new TextButton(
              child: new Text("취소"),
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

class IndiCounselEditor2 extends StatefulWidget {
  var headerData;
  IndiCounselEditor2(this.headerData);

  @override
  IndiCounselEditorState2 createState() => IndiCounselEditorState2(headerData);
}

class IndiCounselEditorState2 extends State<IndiCounselEditor2> {
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _locationController = new TextEditingController();
  final TextEditingController _ageController = new TextEditingController();
  final TextEditingController _fieldController = new TextEditingController();
  final TextEditingController _introduceController =
      new TextEditingController();

  var headerData;
  IndiCounselEditorState2(this.headerData);

  @override
  void initState() {
    super.initState();
    _titleController.text = headerData['title'];
    _locationController.text = headerData['location'];
    _ageController.text = headerData['age'];
    _fieldController.text = headerData['field'];
    _introduceController.text = headerData['introduce'];
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
                      '개인 상담소 정보 수정',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildCustomTextField(
                      '상담소 이름', _titleController, TextInputType.text),
                  _buildCustomTextField(
                      '지역', _locationController, TextInputType.text),
                  _buildCustomTextField(
                      '나이', _ageController, TextInputType.numberWithOptions()),
                  _buildCustomTextField(
                      '분야', _fieldController, TextInputType.text),
                  _buildCustomTextField(
                      '소개', _introduceController, TextInputType.text),
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

  void _deleteCouncelCenter(String name) {
    firestore.collection('individualCouncel').doc(name).delete();
  }

  void _confirm() {
    String output = '다음은 필수 기재 항목입니다.\n';
    bool empty = false;
    if (isEmpty(_titleController.text)) {
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

      _deleteCouncelCenter(header.counselCenterName);

      firestore
          .collection('member')
          .doc(header.userId)
          .update({'counselCenterName': time});

      setState(() => {
            header.counselCenterName = time,
            header.myCounselCenter = {
              'age': _ageController.text,
              'field': _fieldController.text,
              'hostId': header.userId,
              'hostname': header.userName,
              'introduce': _introduceController.text,
              'location': _locationController.text,
              'phone': header.phoneNum, //사용자 계정.text,
              'title': _titleController.text,
            },
            firestore
                .collection('individualCouncel')
                .doc(time)
                .set(header.myCounselCenter)
          });

      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => IndiCounselEditor()));
      _alert('성공적으로 변경되었습니다!');
    }
  }
}
