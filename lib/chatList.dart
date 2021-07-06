import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'const.dart';
import 'chatBoth.dart' as chat;

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  void _popupMenu([String text]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialogs
        return AlertDialog(
          title: Center(
              child: new Text(
            text,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          )),
          content: new SingleChildScrollView(
              child: Column(
            children: [
              ListTile(
                title: Text(
                  '삭제',
                  textAlign: TextAlign.center,
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  '차단',
                  textAlign: TextAlign.center,
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  '수신 거부',
                  textAlign: TextAlign.center,
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
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildItem(context, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      //tileColor: Colors.yellowAccent[100],
      selectedTileColor: Colors.amber[200],
      //hoverColor: Colors.blueAccent[400],
      shape: RoundedRectangleBorder(),
      title: Text(
        document.data()['name'],
        textAlign: TextAlign.left,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => chat.ChatScreen(document)),
        );
      },
      onLongPress: () {
        _popupMenu(document.data()['name']);
      },
    );
  }
}
