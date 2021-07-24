import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chatBoth.dart' as chat;
import 'header.dart' as header;
import 'dart:math' as math;

class Community extends StatefulWidget {
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final List themeList = [
    '인권상담',
    '법률상담',
    '군대',
    '학업',
    '취업',
    '연애',
    '심리',
    '취미',
    '운동',
    '기타(etc)',
    '나의 상담소'
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
          body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('individualCouncel')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  itemBuilder: (context, index) =>
                      buildCard(context, snapshot.data.documents[index], index),
                  itemCount: snapshot.data.documents.length,
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
              //Positioned(left: 12, bottom: 18, child: Text('방문자수: ', style: TextStyle()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(
                        'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'),
                  ),
                  const SizedBox(height: 4),
                  Text(document.data()['title'] ?? 'undefined',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                    child: Text(document.data()['introduce'] ?? '소개가 없습니다',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal)),
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
                            String councelHostId =
                                document.data()['hostId'] ?? null;
                            if (councelHostId == null)
                              _alertError();
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
                      TextButton(
                        child: Text(
                          '상세보기',
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        onPressed: () {
                          _popupMenu([
                            document.data()['title'] ?? 'undefined',
                            document.data()['hostname'] ?? 'undefined',
                            document.data()['age'] ?? 'undefined',
                            document.data()['field'] ?? 'undefined',
                            document.data()['location'] ?? 'undefined',
                            document.data()['phone'] ?? 'undefined',
                          ]); //각
                        },
                      ),
                    ],
                  )
                ],
              ),
            ]),
          ));

  void _alertError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialogs
        return AlertDialog(
          title: new Center(
            child: Text('오류'),
          ),
          content: SingleChildScrollView(
            child: Center(child: Text('유저 정보가 없습니다')),
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

  void _popupMenu(List<String> hostInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialogs
        return AlertDialog(
          title: new Center(
              child: Text(
            hostInfo[0],
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )),
          content: new SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('호스트 : ' + hostInfo[1],
                  textAlign: TextAlign.left, style: TextStyle(fontSize: 18)),
              Text('나이 : ' + hostInfo[2],
                  textAlign: TextAlign.left, style: TextStyle(fontSize: 18)),
              Text('지역 : ' + hostInfo[3],
                  textAlign: TextAlign.left, style: TextStyle(fontSize: 18)),
              Text('분야 : ' + hostInfo[4],
                  textAlign: TextAlign.left, style: TextStyle(fontSize: 18)),
              Text('연락처 : ' + hostInfo[5],
                  textAlign: TextAlign.left, style: TextStyle(fontSize: 18)),
            ],
          )),
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
