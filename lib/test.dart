import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'header.dart' as header;

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

  int curUserId;
  int oppoUserId;
  int chatUrl;

  List curChatList = [];
  List oppoChatList = [];

  int lastReadIndex = 0;

  bool alreadyExist = false;
  bool isNewChat = false;
  _ChatScreenState(this.document);

  List whatSaid = [];

  @override
  void initState() {
    super.initState();
    curUserId = header.userArmyNum.hashCode;
    oppoUserId = document.data()['armyNum'].hashCode;
    if (curUserId >= oppoUserId) {
      chatUrl = curUserId - oppoUserId;
    } else {
      chatUrl = oppoUserId - curUserId;
    }
    isAlreadyExist();

    fetchStream() ? print('Stream Fetch Complete') : print('error occured');
  }

  bool fetchStream() {
    FirebaseFirestore.instance
        .collection('chat')
        .doc('$chatUrl')
        .snapshots()
        .listen((snapshot) {
      //print(snapshot);
      //print(snapshot.hasData);
      //if (snapshot.hasData) {
      FirebaseFirestore.instance
          .collection('chat')
          .doc('$chatUrl')
          .get()
          .then((DocumentSnapshot ds) {
        whatSaid = ds.data()['whatSaid'];
        //print('whatSaid:');
        //print(whatSaid.length);
        print(whatSaid);

        if (ds != null) {
          var i;
          for (i = lastReadIndex; i < whatSaid.length; i++) {
            try {
              print('now:$i');
              _insertSingleItem(ChatMessage(
                text: whatSaid[i] ?? '????????? ??????',
                animationController: AnimationController(
                  duration: Duration(milliseconds: 700),
                  vsync: this,
                ),
              ));
            } catch (e) {
              print('error');
            }
          }
          lastReadIndex = (whatSaid.length);
          //print(whatSaid.length - 1);
        }
        //return Future<String>
      });
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
        .doc(document.data()['id']) // doc 
        .get()
        .then((DocumentSnapshot ds) {
      oppoChatList = ds.data()['chatList'];
    });

    //print('curchatList:' + '$curChatList');
    //print('chatUrl: ' + '$chatUrl');
    if (curChatList.contains(chatUrl) || oppoChatList.contains(chatUrl)) return;

    print('Firebase ????????? ?????????');

    FirebaseFirestore.instance
        .collection('chat')
        .doc('$chatUrl')
        .set({"whatSaid": []});

    curChatList.add(chatUrl);
    oppoChatList.add(chatUrl);

    print("Firebase ??? ???????????? ??????");
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
          title: new Text("??????"),
          content: new Text(text ?? "????????? ?????? ??????????????? ??????????????????"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("??????"),
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
        _queryController.clear();
      }
    }
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
    var bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: TextField(
              decoration:
                  InputDecoration(hintText: "  ViewInsets.bottom =  $bottom"))),
    );
  }

  Future<void> executeAfterBuild() async {
    print('a');
  }
}

class ChatMessage extends StatelessWidget {
  final String text; // ????????? ?????????
  final AnimationController animationController; // ??????????????? ????????? ??? ????????? ??????

  ChatMessage({this.text, this.animationController});

  @override
  Widget build(BuildContext context) {
    // ????????? ?????????????????? ???????????? ?????? SizeTransition??? ??????
    return SafeArea(
      child: SizeTransition(
        // ????????? ??????????????? ?????? ??????
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        // ??????????????? ????????? ???????????? ??????
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                // ??????????????? ????????? ????????? ?????? ???????????? ??????
                child: CircleAvatar(child: Text(header.userName[0])),
              ),
              Expanded(
                // ?????? ??????
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      // ??????????????? subhead ????????? ??????
                      Text(header.userName,
                          style: Theme.of(context).textTheme.subtitle1),
                      // ???????????? ????????? ??????
                      Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: Text(text),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
