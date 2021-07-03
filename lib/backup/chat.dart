import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../header.dart' as header;

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

  String curUserId;
  String oppoUserId;
  int chatUrl;

  bool alreadyExist = false;
  _ChatScreenState(this.document);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    curUserId = header.userArmyNum;
    oppoUserId = document.data()['armyNum'];
    if (curUserId.hashCode >= oppoUserId.hashCode) {
      chatUrl = '$curUserId-$oppoUserId'.hashCode;
    } else {
      chatUrl = '$oppoUserId-$curUserId'.hashCode;
    }
    isAlreadyExist();
  }

  void isAlreadyExist() async {
    print('yey');
    final snapShot = await FirebaseFirestore.instance
        .collection('member')
        .doc(header.userId)
        .collection('chatList')
        .doc('$chatUrl')
        .get();

    final oppoSnapShot = await FirebaseFirestore.instance
        .collection('member')
        .doc(document.data()['id'])
        .collection('chatList')
        .doc('$chatUrl')
        .get();
    print(snapShot == null);
    print(!snapShot.exists);
    print(oppoSnapShot == null);
    print(!oppoSnapShot.exists);

    if (!(snapShot == null ||
        !snapShot.exists ||
        oppoSnapShot == null ||
        !oppoSnapShot.exists)) {
      print('yey');
      FirebaseFirestore.instance
          .collection('member')
          .doc(header.userId)
          .collection('chatList')
          .doc('$chatUrl')
          .set({});

      FirebaseFirestore.instance
          .collection('member')
          .doc(document.data()['id'])
          .collection('chatList')
          .doc('$chatUrl')
          .set({});
    }
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
            new ElevatedButton(
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
    _message.add(message);
    _listKey.currentState.insertItem(_message.length - 1);
  }

  void _getResponse() {
    if (_queryController.text.length > 0) {
      try {
        this._insertSingleItem(ChatMessage(
          text: _queryController.text,
          animationController: AnimationController(
            duration: Duration(milliseconds: 700),
            vsync: this,
          ),
        ));
      } catch (e) {
        print("Failed -> $e");
      } finally {
        if (!(_message.length > 1)) {
          isAlreadyExist();
        }
        _queryController.clear();
      }
    }
  }

  Widget _buildItem(ChatMessage item, Animation animation, int index) {
    String chatContent = item.text;
    bool mine = !chatContent.endsWith('<oppo>');
    chatContent = chatContent.replaceAll('<oppo>', '');
    print(chatContent);
    return SafeArea(
      child: SizeTransition(
          axisAlignment: 1.0,
          sizeFactor: animation,
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Container(
                alignment: mine ? Alignment.bottomLeft : Alignment.bottomRight,
                child: Bubble(
                  child: Text(chatContent),
                  color: mine ? Colors.blue : Colors.yellow,
                  padding: BubbleEdges.all(10),
                )),
          )),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
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
      body: SafeArea(
          child: Stack(
        children: [
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('member')
                  .doc(header.userId)
                  .collection('chatList')
                  .doc('$chatUrl')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _insertSingleItem(ChatMessage(
                    text: snapshot.data.get('test') ?? '그런거 없쪙',
                    animationController: AnimationController(
                      duration: Duration(milliseconds: 700),
                      vsync: this,
                    ),
                  ));
                }
                return AnimatedList(
                  reverse: true,
                  key: _listKey,
                  itemBuilder: (BuildContext context, int index,
                      Animation<double> animation) {
                    return _buildItem(_message[index], animation, index);
                  },
                );
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextField(
              autofocus: true,
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
                _queryController.text.replaceAll("<oppo>", "");
                _queryController.text = _queryController.text + '<oppo>';
                this._getResponse();
                FirebaseFirestore.instance
                    .collection('member')
                    .doc(document.data()['id'])
                    .collection('chatList')
                    .doc('$chatUrl')
                    .update({"test": msg});
              },
            ),
          )
        ],
      )),
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
