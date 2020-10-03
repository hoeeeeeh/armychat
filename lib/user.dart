import 'package:flutter/material.dart';
import 'setting.dart' as setting;
import 'counselor.dart' as counselor;
import 'chatbot.dart' as bot;
import 'home.dart' as home;

class UserInfo extends StatefulWidget {
  UserInfo({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  int _selectedIndex = 0;

  final List<Widget> _widgetArray = <Widget>[
    home.Homepage(),
    counselor.CounSel(),
    setting.Setting(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: Text(widget.title ?? 'default value'),
      ),
      */
      body: Center(
        child: _widgetArray.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: '상담하기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
