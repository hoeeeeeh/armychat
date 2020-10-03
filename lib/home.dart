import 'header.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  var _calendarController;
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('홈'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
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
                tiles: [
                  ListTile(
                      title: Text('예약한 상담 1'), leading: Icon(Icons.bookmark)),
                  ListTile(
                      title: Text('예약한 상담 2'),
                      leading: Icon(Icons.bookmark_border_outlined)),
                  ListTile(
                      title: Text('예약한 상담 3'),
                      leading: Icon(Icons.bookmark_border_outlined)),
                ],
              ).toList(),
            )),
          )
        ],
      )),
    );
  }
}
