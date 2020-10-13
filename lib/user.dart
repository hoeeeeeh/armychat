import 'package:flutter/material.dart';
import 'setting.dart' as setting;
import 'counselor.dart' as counselor;
import 'chatbot.dart' as bot;
import 'home.dart' as home;

class Userinfo extends StatefulWidget {
  // Userinfo({Key key, this.title}) : super(key: key);
  // final String title;
  final String userName;
  final String email;
  final String id;

  Userinfo(this.userName, this.email, this.id) {
    print(userName + email);
  }

  Userinfo.nonFastLogin(this.userName, this.email, this.id) {
    print(userName + email);
  }

  @override
  _UserinfoState createState() => _UserinfoState(userName, email, id);
}

class _UserinfoState extends State<Userinfo> {
  int _selectedIndex = 0;

  final String userName;
  final String email;
  final String id;
  List<Widget> _widgetArray;

  _UserinfoState(this.userName, this.email, this.id) {
    _widgetArray = <Widget>[
      home.Homepage(id, userName, email),
      counselor.CounSel(id),
      bot.ChatScreen(),
      setting.Setting(),
    ];
  }

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
            backgroundColor: Colors.green,
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: Icon(Icons.chat_bubble),
            label: '상담관과 상담하기',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: Icon(Icons.chat_sharp),
            label: '챗봇과 상담하기',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.grey,
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[400],
        onTap: _onItemTapped,
      ),
    );
  }
}
