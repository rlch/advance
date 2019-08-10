import 'package:flutter/material.dart';

class Progress extends StatefulWidget {
  Progress({Key key}) : super(key: key);

  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          labelColor: Colors.black,
          indicatorColor: Colors.black.withOpacity(0.17),
          tabs: <Widget>[
            Tab(
              text: "Me",
            ),
            Tab(text: "Friends",)
          ],
        ),
      ),
    );
  }
}
