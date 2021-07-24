import 'package:flutter/material.dart';
import 'setting.dart' as setting;
import 'community.dart' as community;
//import 'chatbot.dart' as bot;
import 'home.dart' as home;
import 'chatList.dart' as chatList;
import 'friend.dart' as friend;
import 'counselor.dart' as counselor;
import 'package:flutter_icons/flutter_icons.dart';

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
  int _selectedIndex = 2;

  final String userName;
  final String email;
  final String id;
  List<Widget> _widgetArray;

  _UserinfoState(this.userName, this.email, this.id) {
    _widgetArray = <Widget>[
      friend.friendList(),
      community.Community(),
      home.Homepage(id, userName, email),
      counselor.CounSel(id),
      chatList.ChatList(),
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
            backgroundColor: Colors.pinkAccent[100],
            icon: Icon(Icons.people_rounded),
            label: '상담친구',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.lightBlueAccent[400],
            icon: Icon(Icons.house_siding),
            label: '개인상담소',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.green,
            icon: Icon(Icons.home_filled),
            label: '홈',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blueAccent[100],
            icon: Icon(AntDesign.smile_circle),
            label: '상담관과 상담하기',
          ),

          /*
          
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: Icon(Icons.chat_sharp),
            label: '실시간 상담',
          ),
          */
          /*
          BottomNavigationBarItem(
            backgroundColor: Colors.redAccent[100],
            icon: Icon(AntDesign.message1),
            label: '채팅',
          ),
          */
          BottomNavigationBarItem(
            backgroundColor: Colors.grey,
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellowAccent[100],
        onTap: _onItemTapped,
      ),
    );
  }
}
