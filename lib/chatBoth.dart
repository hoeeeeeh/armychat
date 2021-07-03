import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:safe_area_height/safe_area_height.dart';
import 'header.dart' as header;
import 'package:keyboard_visibility/keyboard_visibility.dart';

class ChatScreen extends StatefulWidget {
  final DocumentSnapshot document;
  ChatScreen(this.document);

  _ChatScreenState createState() => _ChatScreenState(document);
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _message = <ChatMessage>[];
  final DocumentSnapshot document;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController _queryController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  int curUserId;
  int oppoUserId;
  int chatUrl;

  double height;
  double keyboardHeight = 0.0;
  List curChatList = [];
  List oppoChatList = [];

  int lastReadIndex = 0;

  double _safeAreaHeight = 0;
  double _safeAreaHeightBottom = 0;

  bool makeDone = false;
  _ChatScreenState(this.document);

  Stream<DocumentSnapshot> firebaseStream;

  KeyboardVisibilityNotification _keyboardVisibility =
      new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;

  List whatSaid = [];

  @override
  void initState() {
    super.initState();

    whatSaid = [];
    getSafeAreaHeight();
    curUserId = header.userArmyNum.hashCode;
    oppoUserId = document.data()['armyNum'].hashCode;
    if (curUserId >= oppoUserId) {
      chatUrl = curUserId - oppoUserId;
    } else {
      chatUrl = oppoUserId - curUserId;
    }
    isAlreadyExist();

    firebaseStream = FirebaseFirestore.instance
        .collection('chat')
        .doc('$chatUrl')
        .snapshots();

    //WidgetsBinding.instance
    //   .addPostFrameCallback((_) => _updateData());
    /*
    _keyboardState = _keyboardVisibility.isKeyboardVisible;

    _keyboardVisibilitySubscriberId =
        _keyboardVisibility.addNewListener(onChange: (visible) {
      print(visible);
      if (visible) {
        print(MediaQuery.of(context).viewInsets.bottom);
        setState(() {
          
          keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        });
      } else {
        print(MediaQuery.of(context).viewInsets.bottom);
        setState(() {
          keyboardHeight = 0.0;
        });
      }
    });
    */
  }

  @override
  void dispose() {
    super.dispose();
    _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
  }

  Future<void> getSafeAreaHeight() async {
    double safeAreaHeight = 0;
    double safeAreaHeightBottom = 0;

    safeAreaHeight = await SafeAreaHeight.safeAreaHeightTop;
    safeAreaHeightBottom = await SafeAreaHeight.safeAreaHeightBottom;

    setState(() {
      _safeAreaHeight = safeAreaHeight;
      _safeAreaHeightBottom = safeAreaHeightBottom;
    });
  }

  void isAlreadyExist() async {
    await FirebaseFirestore.instance
        .collection('member')
        .doc(header.userId)
        .get()
        .then((DocumentSnapshot ds) {
      curChatList = ds.data()['chatList'];
    });

    await FirebaseFirestore.instance
        .collection('member')
        .doc(document.data()['id'])
        .get()
        .then((DocumentSnapshot ds) {
      oppoChatList = ds.data()['chatList'];
    });

    print('curchatList:' + '$curChatList');
    print('chatUrl: ' + '$chatUrl');
    if (curChatList.contains(chatUrl) || oppoChatList.contains(chatUrl)) return;

    FirebaseFirestore.instance
        .collection('chat')
        .doc('$chatUrl')
        .set({"whatSaid": []});

    curChatList.add(chatUrl);
    oppoChatList.add(chatUrl);
    FirebaseFirestore.instance
        .collection('member')
        .doc(header.userId)
        .update({'chatList': curChatList});
    FirebaseFirestore.instance
        .collection('member')
        .doc(document.data()['id'])
        .update({'chatList': oppoChatList});
  }

  void _alert([String text]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialogs
        return AlertDialog(
          title: new Text("입력"),
          content: new Text(text ?? "아이디 혹은 비밀번호를 입력해주세요"),
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

  void _insertSingleItem(ChatMessage message) {
    //String contents = message.text;
    //_message.add(message);
    _message.insert(0, message);
    _listKey.currentState.insertItem(0);
  }

  Widget _buildItem(ChatMessage item, Animation animation, int index) {
    String chatContent = item.text;
    bool mine;

    if (mine = chatContent.startsWith('<$curUserId>')) {
      chatContent = chatContent.replaceFirst('<$curUserId>', '');
    } else {
      chatContent = chatContent.replaceFirst('<$oppoUserId>', '');
    }
    //print(chatContent);
    //print(chatContent);
    return SafeArea(
      child: SizeTransition(
          axisAlignment: 1.0,
          sizeFactor: animation,
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Container(
                alignment: mine ? Alignment.bottomRight : Alignment.bottomLeft,
                child: Bubble(
                  child: Text(chatContent),
                  color: mine ? Colors.blue : Colors.yellow,
                  padding: BubbleEdges.all(10),
                )),
          )),
    );
  }

  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    //print(MediaQuery.of(context).size.height);
    //print(height);
    print('build');
    whatSaid = [];
    //scrollToEnd();
    print('afterCallback');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.05),
        child: AppBar(
          //backgroundColor: Colors.white,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, size: 30),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            document.data()['name'] + "님 과의 대화" + '$chatUrl',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
            child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream: firebaseStream,
                builder: (context, snapshot) {
                  //print('streamBuilder builder');
                  //print(snapshot);
                  //
                  //print(snapshot.hasData);
                  print('snapshot off');
                  if (snapshot.hasData) {
                    print('snapshot on');
                    FirebaseFirestore.instance
                        .collection('chat')
                        .doc('$chatUrl')
                        .get()
                        .then((DocumentSnapshot ds) {
                      //whatSaid = ds.data()['whatSaid'] ?? [];

                      if (ds != null && ds.data() != null) {
                        print('aaaaa');
                        print(ds.data());
                        print('bbbbb');
                        print(ds.data()['whatSaid']);
                        whatSaid = ds.data()['whatSaid'] ?? [];
                        for (var i = lastReadIndex; i < whatSaid.length; i++) {
                          _insertSingleItem(ChatMessage(
                            text: whatSaid[i] ?? '그런거 없쪙',
                            animationController: AnimationController(
                              duration: Duration(milliseconds: 700),
                              vsync: this,
                            ),
                          ));
                        }
                        //print(whatSaid);
                        lastReadIndex = (whatSaid.length);
                        //print(whatSaid.length - 1);
                      }
                      //return Future<String>
                    });
                  }

                  //print('out of streamBuilder');
                  return SizedBox(
                    height: (height * 0.90) -
                        (_safeAreaHeightBottom + _safeAreaHeight) -
                        MediaQuery.of(context).viewInsets.bottom, // 키보드 올라오면

                    child: AnimatedList(
                      controller: _scrollController,
                      shrinkWrap: true,
                      reverse: true,
                      key: _listKey,
                      itemBuilder: (BuildContext context, int index,
                          Animation<double> animation) {
                        //print('buildItem');
                        return _buildItem(_message[index], animation, index);
                      },
                    ),
                  );
                }),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: height * 0.05,
                //height: 50,
                child: TextField(
                  //autofocus: true,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.message,
                      color: Colors.greenAccent,
                    ),
                    hintText: "채팅을 입력해주세요.",
                  ),
                  controller: _queryController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (msg) {
                    _queryController.text =
                        '<$curUserId>' + _queryController.text;
                    whatSaid.add(_queryController.text);
                    _queryController.clear();
                    FirebaseFirestore.instance
                        .collection('chat')
                        .doc('$chatUrl')
                        .update({"whatSaid": whatSaid});
                  },
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text; // 출력할 메시지
  final AnimationController animationController; // 리스트뷰에 등록될 때 보여질 효과

  ChatMessage({this.text, this.animationController});

  @override
  Widget build(BuildContext context) {
    // 위젯에 애니메이션을 발생하기 위해 SizeTransition을 추가
    return SafeArea(
      child: SizeTransition(
        // 사용할 애니메이션 효과 설정
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        // 리스트뷰에 추가될 컨테이너 위젯
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                // 사용자명의 첫번째 글자를 서클 아바타로 표시
                child: CircleAvatar(child: Text(header.userName[0])),
              ),
              Expanded(
                // 컬럼 추가
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    // 사용자명을 subhead 테마로 출력
                    Text(header.userName,
                        style: Theme.of(context).textTheme.subtitle1),
                    // 입력받은 메시지 출력
                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: Text(text),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}