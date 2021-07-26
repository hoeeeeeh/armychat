import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chatBoth.dart' as chat;
import 'header.dart' as header;

class CounselManage extends StatefulWidget {
  @override
  CounselManageState createState() => CounselManageState();
}

class CounselManageState extends State<CounselManage> {
  int counselCount;
  int count = 0;
  String title = "";
  List<Widget> counselList = [];
  var myDocument;

  @override
  initState() {
    super.initState();
    init();
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
          title: Text('상담 내역',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 10,
          shadowColor: Colors.black,
        ),
      ),
      body: SafeArea(child: buildList(counselList.length == 0)));

  Widget buildList(bool isEmpty) {
    if (isEmpty)
      return Center(
        child: Text(
          '상담 내역이 없습니다.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    else
      return Center(
          child: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: counselList,
        ).toList(),
      ));
  }

  void _deleteCounsel(String dataname) {
    FirebaseFirestore.instance.collection('expert').doc(dataname).delete();

    List myCounselList = myDocument.data()['counselList'] ?? [];
    myCounselList.remove(dataname);

    FirebaseFirestore.instance
        .collection('member')
        .doc(header.userId)
        .update({'counselList': myCounselList}).then((data) {
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CounselManage()));
      _alert('삭제되었습니다');
    });
  }

  void _requestChat(String msg, DocumentSnapshot document) {
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => chat.ChatScreen(document)));
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

  void _requestDelete(String msg, String data) {
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
                _deleteCounsel(data);
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

  Future<void> init() async {
    myDocument = await FirebaseFirestore.instance
        .collection("member")
        .doc(header.userId)
        .get();

    List myCounselList = myDocument.data()['counselList'] ?? [];

    String title = "";
    String content = "";

    for (int i = 0; i < myCounselList.length; i++) {
      final counselElem = await FirebaseFirestore.instance
          .collection("expert")
          .doc(myCounselList[i])
          .get(); //상담내역 가져옴

      print(counselElem.data());

      title = counselElem.data()['title'] != ''
          ? counselElem.data()['title']
          : 'untitled';
      content = counselElem.data()['content'] != ''
          ? counselElem.data()['content']
          : 'no data';

      //시간 표시 (상담 요소 id)
      counselList.add(Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
        child: Text(myCounselList[i].toString().split(' ')[0],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
      ));
      //내 질문 카드
      counselList.add(Container(
        margin: EdgeInsets.fromLTRB(125, 5, 10, 5),
        child: Card(
            shadowColor: Colors.black.withOpacity(0.9),
            color: Colors.white,
            elevation: 10,
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: Stack(children: [
                //Positioned(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 4),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Text(
                        content,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    ButtonBar(
                      buttonPadding: EdgeInsets.all(3),
                      alignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text(
                            '삭제',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          onPressed: () {
                            _requestDelete('정말로 삭제하시겠습니까?', myCounselList[i]);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ]),
            )),
      ));

      //reply Card
      List _replyList = counselElem.data()['replylist'] ?? [];
      List _replierList = counselElem.data()['replierlist'] ?? [];
      List _replierNameList = counselElem.data()['repliername'] ?? [];

      for (int count = 0; count < _replyList.length; ++count) {
        String ___reply = _replyList[count];
        String ___replier = _replierList[count];
        ___replier = ___replier != '' ? ___replier : '익명';
        String ___replierName = _replierNameList[count];
        ___replierName = ___replierName != '' ? ___replierName : '익명';

        counselList.add(Container(
          margin: EdgeInsets.fromLTRB(20, 5, 125, 5),
          child: Card(
              shadowColor: Colors.black.withOpacity(0.9),
              color: Colors.white,
              elevation: 10,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Stack(children: [
                  //Positioned(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 4),
                      //replier
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10, 0, 5, 5),
                        child: Text(
                          ___replierName,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      //reply content
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                        child: Text(
                          ___reply,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      ButtonBar(
                        buttonPadding: EdgeInsets.all(3),
                        alignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              child: Text(
                                '대화하기',
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              onPressed: () {
                                if (___replier == "")
                                  _alert('익명 사용자와는 대화할 수 없습니다');
                                else {
                                  FirebaseFirestore.instance
                                      .collection('member')
                                      .doc(___replier)
                                      .get()
                                      .then((document) {
                                    _requestChat('상담원과 대화하시겠습니까?', document);
                                  });
                                }
                              }),
                        ],
                      )
                    ],
                  ),
                ]),
              )),
        ));
      }
    }

    setState(() {
      print(counselList);
    });
  }
}
