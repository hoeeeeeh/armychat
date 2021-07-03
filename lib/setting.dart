import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'header.dart' as header;

class Setting extends StatefulWidget {
  Setting({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  void darkMode(bool value) {
    setState(() {
      header.isDarkMode = !(header.isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return SafeArea(
      child: Scaffold(
          body: Center(
              child: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
                title: Text('개인 상담소 열기'),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => IndiCounsel())),
                leading: Icon(Icons.meeting_room)),
            ListTile(
                title: Text('만든 이'),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MakingNotes())),
                leading: Icon(Icons.people)),
            // ListTile(
            //   title: Text('설정 1'),
            // ),
            ListTile(
                title: Text('로그아웃'),
                onTap: () async {
                  Navigator.pop(context);
                  //await header._auth.signOut();
                },
                leading: Icon(Icons.exit_to_app)),
          

            ListTile(
              title: Text(
                '앱에 관련된 문의사항은 \n hoeeeeeh@gmail.com으로 문의주세요!!',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ).toList(),
      ))),
    );
  }
}

class B extends StatefulWidget {
  B({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _BState createState() => _BState();
}

class _BState extends State<B> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}
/* 
Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('다크 모드'),
                CupertinoSwitch(
                  value: header.isDarkMode,
                  onChanged: darkMode,
                ),
              ],
            ),
            Container(
              child: Text(
                '만든 이',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ))
        // This trailing comma makes auto-formatting nicer for build methods.
        );
*/

class MakingNotes extends StatefulWidget {
  MakingNotes({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MakingNotesState createState() => _MakingNotesState();
}

class _MakingNotesState extends State<MakingNotes> {
  int count = 0;
  Timer _timer;

  bool _visible = true;
  String text = '개발자 : 병장 유호균, 일병 김영길 등 소프트웨어 동아리 Sudo \n 기획 : 일병 나건우';

  @override
  void initState() {
    super.initState();
    _start();
  }

  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void _start() {
    _timer = Timer.periodic(Duration(seconds: 7), (timer) {
      setState(() {
        if (count == 0) {
          _visible = false;
          count++;
        } else if (count == 1) {
          text =
              '소프트웨어 동아리를 위해 아낌없이 힘 써주신 \n 박필하 대대장님 && 한갑교 중사님, 진심으로 감사드립니다. \n - 소프트웨어 동아리 Sudo 일동';
          _visible = true;
          count++;
        } else if (count == 2) {
          _visible = false;
          count++;
        } else if (count == 3) {
          Navigator.pop(context);
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedOpacity(
      // If the widget is visible, animate to 0.0 (invisible).
      // If the widget is hidden, animate to 1.0 (fully visible).
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      // The green box must be a child of the AnimatedOpacity widget.
      child: Container(
          child: Center(
              child: Text(
        text ?? 'default value',
        textAlign: TextAlign.center,
      ))),
    ));
  }
}

class IndiCounsel extends StatefulWidget {
  @override
  _IndiCounselState createState() => _IndiCounselState();
}

class _IndiCounselState extends State<IndiCounsel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
              child: Text(
        '개인 상담소 정보 입력',
        textAlign: TextAlign.center,
      ))),
    );
  }
}

//   _timer2 = Timer.periodic(Duration(seconds: 10), (timer) {
//     setState(() {
//       text = 'Thanks To 박XX';
//       _timer2.cancel();
//       _visible = true;
//     });
//   });
// }
