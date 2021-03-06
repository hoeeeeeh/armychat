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
          title: new Text("??????"),
          content: new Text(text ?? "????????? ?????? ??????????????? ??????????????????"),
          actions: <Widget>[
            new ElevatedButton(
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
            document.data()['name'] + "??? ?????? ??????" + '$chatUrl',
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
                    text: snapshot.data.get('test') ?? '????????? ??????',
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
                hintText: "????????? ??????????????????.",
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
