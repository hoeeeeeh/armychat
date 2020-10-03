import 'package:flutter/material.dart';
import 'setting.dart' as setting;
import 'counselor.dart' as counselor;
import 'chatbot.dart' as bot;

class UserInfo extends StatefulWidget {
  UserInfo({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  int _selectedIndex = 0;

  final List<Widget> _widgetArray = <Widget>[
    bot.ChatScreen(),
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
            icon: Icon(Icons.chat),
            title: Text('챗봇 상담'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            title: Text('상담관님께 상담'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('설정'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
