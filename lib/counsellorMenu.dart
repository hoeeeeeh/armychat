import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chatBoth.dart' as chat;
import 'header.dart' as header;

class CounsellorMenu extends StatefulWidget {
  @override
  CounsellorMenuState createState() => CounsellorMenuState();
}

class CounsellorMenuState extends State<CounsellorMenu> {
  int counselCount;
  int count = 0;
  String title = "";
  List<ListTile> counselList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.06),
        child: AppBar(
          backgroundColor: Colors.white,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, size: 30),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('상담 관리',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 10,
          shadowColor: Colors.black,
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collectionGroup('expert')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                );
              } else {
                int len = snapshot.data.documents.length;
                if (len < 1)
                  return Center(
                      child: Text('상담 요청이 없습니다',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)));
                else
                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    itemBuilder: (context, index) {
                      return buildCard(
                          context, snapshot.data.documents[index], index);
                    },
                    itemCount: len,
                  );
              }
            }),
      ));

  Widget buildCard(
          BuildContext context, DocumentSnapshot document, int index) =>
      Card(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          shadowColor: Colors.black.withOpacity(0.9),
          color: Colors.white,
          elevation: 10,
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
            child: Stack(children: [
              Positioned(
                left: 12,
                top: 5,
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 4),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(90, 0, 5, 5),
                    child: Text(
                      (document.data()['title'] != ""
                              ? document.data()['title']
                              : 'untitled') +
                          (document.data()['anonymous']
                              ? ' - 익명'
                              : ' - ' + document.data()['userId']),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(90, 0, 5, 0),
                    child: Text(
                      document.data()['content'] != ""
                          ? document.data()['content']
                          : '내용이 없습니다',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  ButtonBar(
                    buttonPadding: EdgeInsets.all(3),
                    alignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text(
                          '거절',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        onPressed: () {
                          _requestDelete('이 상담을 삭제하시겠습니까?', document);
                        },
                      ),
                      TextButton(
                        child: Text(
                          '답변하기',
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CounsellorReply(document)));
                        },
                      ),
                      TextButton(
                          child: Text(
                            '대화하기',
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          onPressed: () {
                            String councelHostId =
                                document.data()['userId'] != ""
                                    ? document.data()['userId']
                                    : null;
                            bool isAnonymous = document.data()['anonymous'];
                            if (councelHostId == null)
                              _alert('유저 정보가 없습니다');
                            else if (isAnonymous)
                              _alert('익명 사용자와는 대화할 수 없습니다');
                            else {
                              FirebaseFirestore.instance
                                  .collection('member')
                                  .doc(councelHostId)
                                  .get()
                                  .then(
                                (document) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              chat.ChatScreen(document)));
                                },
                              );
                            }
                          }),
                    ],
                  )
                ],
              ),
            ]),
          ));

  void _deleteCounsel(DocumentSnapshot document) {
    String id = document.data()['userId'];
    List userCounselList;

    FirebaseFirestore.instance.collection('member').doc(id).get().then((doc) {
      userCounselList = doc.data()['counselList'];
      userCounselList.remove(document.id);

      FirebaseFirestore.instance
          .collection('member')
          .doc(id)
          .update({'counselList': userCounselList});
      FirebaseFirestore.instance.collection('expert').doc(document.id).delete();
      _alert('삭제되었습니다');
    });
  }

  void _requestDelete(String msg, DocumentSnapshot document) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialogs
        return AlertDialog(
          title: new Center(
            child: Text('알림'),
          ),
          content: SingleChildScrollView(
            child: Center(child: Text(msg)),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text("확인"),
              onPressed: () {
                Navigator.pop(context);
                _deleteCounsel(document);
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

  void _alert(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialogs
        return AlertDialog(
          title: new Center(
            child: Text('알림'),
          ),
          content: SingleChildScrollView(
            child: Center(child: Text(msg)),
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

class CounsellorReply extends StatefulWidget {
  final DocumentSnapshot docu;
  CounsellorReply(this.docu);
  @override
  CounsellorReplyState createState() => CounsellorReplyState(docu);
}

class CounsellorReplyState extends State<CounsellorReply> {
  final DocumentSnapshot docu;
  var data;
  CounsellorReplyState(this.docu);

  TextEditingController _replyController;

  List _replyList = [];
  List _replierList = [];
  List _replierNameList = [];
  String _userId; //사용자 계정
  String _userName;
  String _userEmail;
  String _title;
  String _content;
  bool _isAnonymous;

  @override
  void initState() {
    super.initState();
    data = docu.data();
    _replyController = new TextEditingController();
    _isAnonymous = data['anonymous'] ?? true; //익명여부
    _userId = data['userId'] ?? ""; //사용자 계정
    _userName = !_isAnonymous ? data['name'] : "익명";
    _userEmail = !_isAnonymous ? data['email'] : "익명";
    _title = data['title'] != "" ? data['title'] : "untitled";
    _content = data['content'] != "" ? data['content'] : "no data";

    _replyList = data['replylist'] ?? [];
    _replierList = data['replierlist'] ?? [];
    _replierNameList = data['repliername'] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.06),
        child: AppBar(
          backgroundColor: Colors.white,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, size: 30),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('답변하기',
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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Divider(),
                  _createCustomListTile('이름', '$_userName'),
                  Divider(),
                  _createCustomListTile('제목', '$_title'),
                  Divider(),
                  _createCustomListTile('이메일', '$_userEmail'),
                  Divider(),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(16, 10, 0, 10),
                    child: Text(
                      '내용',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(25, 20, 0, 10),
                    child: Text(
                      '$_content',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Divider(),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(16, 10, 0, 10),
                    child: Text(
                      '답변',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 0, 0, 10),
                    child: SizedBox(
                        height: 300,
                        child: TextField(
                          controller: _replyController,
                          keyboardType: TextInputType.text,
                          //maxLength: 1000,
                          maxLines: 50,
                          decoration: InputDecoration(
                            hintText: '상담내용을 입력해주세요',
                          ),
                          maxLength: 500,
                        )),
                  ),
                  Container(
                      width: 300,
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100)),
                      child: ElevatedButton(
                          onPressed: () {
                            _requestSubmit(
                                '답변을 보내시겠습니까?', _replyController.text);
                          },
                          child: Text("답변하기",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17)),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))))),
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

  void _alert(String msg) {
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
                msg,
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

  void _requestSubmit(String msg, String __reply) {
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
                msg,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text("확인"),
              onPressed: () {
                _submit(__reply);
                Navigator.pop(context);
                Navigator.pop(context);
                setState(() {
                  _alert('답변을 성공적으로 보냈습니다!');
                });
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

  void _submit(String __reply) {
    String ref = docu.id;
    _replyList.add(__reply);
    _replierList.add(header.userId);
    _replierNameList.add(header.userName);
    FirebaseFirestore.instance.collection('expert').doc(ref).update({
      'replylist': _replyList,
      'replierlist': _replierList,
      'repliername': _replierNameList
    });
  }
}
