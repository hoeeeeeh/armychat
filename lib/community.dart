import 'package:flutter/material.dart';
import 'dart:math' as math;

class Community extends StatefulWidget {
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final List themeList = [
    '인권상담',
    '법률상담',
    '군대',
    '학업',
    '취업',
    '연애',
    '심리',
    '취미',
    '운동',
    '기타(etc)',
    '나의 상담소'
  ];

  final List colorList = [
    Colors.redAccent[100],
    Colors.amberAccent[100],
    Colors.lightGreenAccent[100],
    Colors.pinkAccent[100],
    Colors.blueAccent[100],
    Colors.yellowAccent[100],
    Colors.tealAccent[100],
    Colors.purpleAccent[100],
  ];

  Widget makeText(String title, {double width, double height, double font}) { // 텍스트 만드는 함수
    return Container(
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: font ?? 23.0, fontFamily: 'BMHANNAAir'),
        ),
      ),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(width: 0.1),
        boxShadow: [
          BoxShadow(
              blurRadius: 1,
              spreadRadius: 1,
              color: Colors.grey.withOpacity(0.5),
              offset: Offset(0, 1))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StackedList();
  }
}

class StackedList extends StatelessWidget {
  final List<Color> _colors = Colors.primaries;
  static const _minHeight = 16.0;
  static const _maxHeight = 120.0;

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: _colors
            .map(
              (color) => StackedListChild(
                minHeight: _minHeight,
                maxHeight: _colors.indexOf(color) == _colors.length - 1
                    ? MediaQuery.of(context).size.height
                    : _maxHeight,
                pinned: true,
                child: Container(
                  color: _colors.indexOf(color) == 0
                      ? Colors.black
                      : _colors[_colors.indexOf(color) - 1],
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(_minHeight)),
                      color: color,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      );
}

class StackedListChild extends StatelessWidget {
  final double minHeight;
  final double maxHeight;
  final bool pinned;
  final bool floating;
  final Widget child;

  SliverPersistentHeaderDelegate get _delegate => _StackedListDelegate(
      minHeight: minHeight, maxHeight: maxHeight, child: child);

  const StackedListChild({
    Key key,
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
    this.pinned = false,
    this.floating = false,
  })  : assert(child != null),
        assert(minHeight != null),
        assert(maxHeight != null),
        assert(pinned != null),
        assert(floating != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => SliverPersistentHeader(
      key: key, pinned: pinned, floating: floating, delegate: _delegate);
}

class _StackedListDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StackedListDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StackedListDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}


// https://stackoverflow.com/questions/54494024/how-to-make-stacked-card-list-view-in-flutter

 /*
    Scaffold(
        backgroundColor: Colors.white10,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                Align(
                    alignment: Alignment.topCenter,
                    heightFactor: 1.2,
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: makeText(
                          '개인 상담소',
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.5,
                        ),
                      ),
                    )),
                Expanded(
                  child: GridView.count(
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 1,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: MediaQuery.of(context).size.width * 0.05,
                    children: List.generate(themeList.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            /*
                            gradient: LinearGradient(
                              colors: [
                                colorList[index % 8],
                                colorList[(index + 1) % 8]
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                            */
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(width: 0.1),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                  color: Colors.blueGrey.withOpacity(0.5),
                                  offset: Offset(0, 3))
                            ],
                          ),
                          child: GestureDetector(
                            onTap: (){
                              
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Text(themeList[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'BMHANNAAir',
                                  )),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                )
              ],
            ),
          ),
        ));
        */