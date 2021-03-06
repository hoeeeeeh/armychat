import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  final String id;
  final String userName;
  final String email;
  Homepage(this.id, this.userName, this.email);

  @override
  _HomepageState createState() => _HomepageState(id, userName, email);
}

class _HomepageState extends State<Homepage> {
  var _calendarController;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String userName;
  final String email;
  final String id;

  List<ListTile> counselList = [];

  int counselCount;

  bool isDisposed = false;

  _HomepageState(this.id, this.userName, this.email);

  void initState() {
    if (!isDisposed) {
      super.initState();
      try {
        init();
      } catch (e) {
        print('$e Async 동기 작업 중 Dispose 발생');
      }
    }

    _calendarController = CalendarController();
  }

  Future<void> init() async {
    final myDocument = await firestore.collection("member").doc(id).get();

    List myCounselList = myDocument.data()['counselList'] ?? [];

    String title = "";

    if (myCounselList.length == 0 && mounted) {
      // mounted == 위젯 트리 안에 현재 남아있을 경우
      print('yes');
      setState(() {
        counselList.add(ListTile(
            title: Text(
          '예약된 상담이 없습니다.',
          textAlign: TextAlign.center,
        )));
      });
      return;
    }

    for (int i = 0; i < myCounselList.length; i++) {
      final counselElem =
          await firestore.collection("expert").doc(myCounselList[i]).get();

      title = counselElem.data()['title'] ?? "untitled";

      if (mounted) {
        setState(() {
          counselList.add(
            ListTile(
                title: Text('상담#$i :: $title'),
                leading: i == 0
                    ? Icon(Icons.bookmark)
                    : Icon(Icons.bookmark_border_outlined)),
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
    isDisposed = true;
  }

  //앱 종료를 한번 더 물어보는 함수
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('종료'),
            content: Text('정말로 앱을 종료하시겠습니까?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('아니요'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('예'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _onWillPop();
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
              child: SizedBox(
            //width: 400,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                Divider(),
                Center(child: Text(userName + '님(' + email + ') 어서오세요.')),
                Divider(),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                TableCalendar(
                  calendarController: _calendarController,
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text('내 상담 일정', style: TextStyle(fontSize: 16)),
                ),
                SizedBox(
                  height: 600,
                  child: Center(
                      child: ListView(
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: counselList,
                    ).toList(),
                  )),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
