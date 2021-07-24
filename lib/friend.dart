import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'const.dart';

class friendList extends StatefulWidget {
  @override
  _friendListState createState() => _friendListState();
}

class _friendListState extends State<friendList> {
  @override
  void _popupMenu(List<String> text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialogs
        return AlertDialog(
          title: new Center(
              child: Text(
            text[0],
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )),
          content: new SingleChildScrollView(
              child: Column(
            children: [
              ListTile(
                title: Text(
                  '자신있는 분야 - ' + text[1],
                  textAlign: TextAlign.left,
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  '도움받은 전우 - ' + text[2] + '명', // 도움을 준 전우 처리
                  textAlign: TextAlign.left,
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  '평가 - ' + text[3] + '/5.0', // 평가 유지
                  textAlign: TextAlign.left,
                ),
                onTap: () {},
              ),
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

  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('member').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
              ),
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(25.0),
              itemBuilder: (context, index) =>
                  buildItem(context, snapshot.data.documents[index], index),
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          //color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(width: 0.1),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 4,
                spreadRadius: 2,
                color: Colors.black.withOpacity(0.5),
                offset: Offset(0, 2))
          ],
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(),
          title: Center(
            child: Text(
              document.data()['name'],
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BMHANNAAir'),
            ),
          ),
          onTap: () {
            _popupMenu([
              document.data()['name'],
              'd', //자신의 분야
              document.data()['chatList'].length.toString() ?? 0, //도움준사람(채팅개수)
              'score' //평가 점수
            ]);
          },
        ),
      ),
    );
  }
}
