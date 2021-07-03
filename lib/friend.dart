import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'const.dart';

class friendList extends StatefulWidget {
  @override
  _friendListState createState() => _friendListState();
}

class _friendListState extends State<friendList> {
  final List colorList = [
    Colors.redAccent[400],
    Colors.amberAccent[400],
    Colors.lightGreenAccent[400],
    Colors.pinkAccent[400],
    Colors.blueAccent[400],
    Colors.yellowAccent[400],
    Colors.tealAccent[100],
    Colors.purpleAccent[100],
  ];

  @override
  void _popupMenu([String text]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialogs
        return AlertDialog(
          title: new Text("프로필"),
          content: new SingleChildScrollView(
              child: Column(
            children: [
              ListTile(
                title: Text(
                  '전문 분야 : ',
                  textAlign: TextAlign.left,
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  '도움을 준 전우 : ', // 도움을 준 전우 처리
                  textAlign: TextAlign.left,
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  '도움을 받은 전우의 만족도 : ', // 평가 유지
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
              padding: EdgeInsets.all(30.0),
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
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorList[index % 8], colorList[(index + 1) % 8]],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          //color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(width: 0.1),
          boxShadow: [
            BoxShadow(
                blurRadius: 7,
                spreadRadius: 5,
                color: Colors.blueGrey.withOpacity(0.5),
                offset: Offset(0, 3))
          ],
        ),
        child: ListTile( // 롱 프레스 
          //tileColor: Colors.yellowAccent[100],
          selectedTileColor: Colors.amber[200],
          //hoverColor: Colors.blueAccent[400],
          shape: RoundedRectangleBorder(),
          title: Text(
            document.data()['name'],
            textAlign: TextAlign.left,
            style: TextStyle(fontFamily: 'BMHANNAAir'),
          ),
          onTap: () {
            _popupMenu('long press');
            ;
          },
        ),
      ),
    );
  }
}
