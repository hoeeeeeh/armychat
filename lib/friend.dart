import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'const.dart';
import 'header.dart' as header;
import 'chatBoth.dart' as chat;

class friendList extends StatefulWidget {
  @override
  _friendListState createState() => _friendListState();
}

class _friendListState extends State<friendList> {
  double height;
  int flength;

  @override
  Widget build(BuildContext context) {
    flength = header.friendList.length;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.06),
        child: AppBar(
          backgroundColor: Colors.white,
          //Color(0xff1899e9)
          //backgroundColor: Colors.white,
          leading: Text(''),
          title: Center(
            child: Text('내 친구(' + '$flength' + '명)',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          actions: [
            IconButton(icon: Icon(Icons.notifications), onPressed: () {})
          ],
          elevation: 0,
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('member').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('로딩 중 오류가 발생했습니다'),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                ),
              );
            } else {
              if (header.friendList.length > 0) {
                //index 찾는 메서드
                int idx = 0;
                List<int> dataIndex = [];
                for (int i = 0; i < header.friendList.length; ++i) {
                  idx = 0;
                  for (var dc in snapshot.data.documents) {
                    if (dc.data()['id'] == header.friendList[i]) {
                      dataIndex.add(idx);
                      break;
                    }
                    idx++;
                  }
                }

                return ListView.builder(
                  padding: EdgeInsets.all(25.0),
                  itemBuilder: (context, index) {
                    var document = snapshot.data.documents[dataIndex[index]];
                    return buildItem(context, document, index);
                  },
                  //itemCount: snapshot.data.documents.length,
                  itemCount: header.friendList.length,
                );
              } else {
                return Center(
                  child: Text('친구 목록이 비어있습니다.'),
                );
              }
            }
          },
        ),
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
        child: Stack(children: [
          Positioned(
            left: 12,
            top: 6,
            child: CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(
                  'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'),
            ),
          ),
          ListTile(
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
                document.data()['name'], //이름
                document.data()['email'], //이메일
                document.data()['phoneNum'], //폰번
                document.data()['chatList'].length.toString() ??
                    0, //도움준사람(채팅개수)
              ], document.data()['id']);
            },
          ),
        ]),
      ),
    );
  }

  void _popupMenu(List<String> text, String id) {
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
                  '이메일 - ' + text[1],
                  textAlign: TextAlign.left,
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  '휴대폰 번호 - ' + text[2], // 평가 유지
                  textAlign: TextAlign.left,
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  '상담횟수 - ' + text[3] + '명', // 도움을 준 전우 처리
                  textAlign: TextAlign.left,
                ),
                onTap: () {},
              ),
              ListTile(
                  title: ButtonBar(
                alignment: MainAxisAlignment.center,
                buttonPadding: EdgeInsets.all(3),
                children: [
                  TextButton(
                      child: Text(
                        '채팅하기',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.orange),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        FirebaseFirestore.instance
                            .collection('member')
                            .doc(id)
                            .get()
                            .then((document) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      chat.ChatScreen(document)));
                        });
                      }),
                  TextButton(
                    child: Text(
                      '친구삭제',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _alert('정말로 삭제하시겠습니까?', id);
                    },
                  ),
                ],
              )),
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

  void _alert(String text, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialogs
        return AlertDialog(
          title: new Text("알림"),
          content: new Text(text ?? ''),
          actions: <Widget>[
            new TextButton(
              child: new Text("확인"),
              onPressed: () {
                Navigator.pop(context);
                deleteFriend(id);
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

  void deleteFriend(String id) {
    if (header.friendList.contains(id)) {
      header.friendList.remove(id);
      setState(() => {flength = header.friendList.length});

      print(header.friendList);

      FirebaseFirestore.instance
          .collection('member')
          .doc(header.userId)
          .update({'friendList': header.friendList});
    }
  }
}
