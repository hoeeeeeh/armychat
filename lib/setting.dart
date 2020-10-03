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
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title ?? '설정'),
        ),
        body: Center(
            child: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                  title: Text('만든 이'),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MakingNotes())),
                  leading: Icon(Icons.people)),
              ListTile(
                title: Text('설정 1'),
              ),
              ListTile(
                title: Text('설정 2'),
              ),
            ],
          ).toList(),
        )));
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
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? 'CHAT'),
        ),
        body: Container());
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
  @override
  Timer _timer;
  Timer _timer2;
  bool _visible = true;
  String text = '개발자 : 병장 유XX, 일병 김XX \n 기획 : 일병 나XX';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _start();
  }

  void _start() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _visible = false;
        _timer.cancel();
      });
    });

    _timer2 = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        text = 'Thanks To 박XX';
        _timer2.cancel();
        _visible = true;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('만든 이')),
        body: AnimatedOpacity(
          // If the widget is visible, animate to 0.0 (invisible).
          // If the widget is hidden, animate to 1.0 (fully visible).
          opacity: _visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          // The green box must be a child of the AnimatedOpacity widget.
          child: Container(child: Center(child: Text(text ?? 'default value'))),
        ));
  }
}
