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
    final temp = await firestore.collection("member").doc(id).get();

    counselCount = temp.data()['counselCount'] ?? 0;
    int count = 0;
    String title = "";

    if (counselCount == 0 && mounted) { // mounted == 위젯 트리 안에 현재 남아있을 경우
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

    for (int i = 0; i < counselCount; i++) {
      count = i + 1;

      final temp2 = await firestore
          .collection("member")
          .doc(id)
          .collection('counsel')
          .doc('counsel#($count)')
          .get();

      title = temp2.data()['title'];
      if (mounted) {
        setState(() {
          counselList.add(
            ListTile(
                title: Text('상담#$count :: $title'),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            child: SizedBox(
          //width: 400,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              Center(child: Text(userName + '님(' + email + ') 어서오세요.')),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              Container(
                padding: EdgeInsets.only(top: 20.0),
                child: Text('내 상담 확인하기'),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ))),
              ),
              TableCalendar(
                calendarController: _calendarController,
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
    );
  }
}
