import 'package:advance/components/exercise.dart';
import 'package:advance/components/user.dart';
import 'package:advance/components/workout_area.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../styleguide.dart';

class RepSetScreen extends StatefulWidget {
  final RepSet repSet;
  final WorkoutArea workoutArea;

  RepSetScreen({Key key, this.repSet, this.workoutArea}) : super(key: key);

  @override
  _RepSetScreenState createState() => _RepSetScreenState();
}

class _RepSetScreenState extends State<RepSetScreen> {
  void _continue() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
              tag: "background-${widget.workoutArea.title}",
              child: DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: user.appTheme.gradientColors,
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft)),
              )),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AppBar(
                  elevation: 0.0,
                  centerTitle: true,
                  title: Text(
                    widget.repSet.title,
                    style: AppTheme.heading,
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: IconButton(
                      iconSize: 40,
                      icon: Icon(Icons.close),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                ),
                Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.repSet.reps.toString(),
                      style: TextStyle(
                          fontFamily: "WorkSans",
                          fontSize: 70,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                    Text(
                      "REPS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: RaisedButton(
                    elevation: 8,
                    color: Colors.white,
                    textColor: user.appTheme.themeColor.primary,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 22),
                    onPressed: () => _continue(),
                    child: Text(
                      "Continue",
                      style: TextStyle(fontSize: 20, fontFamily: "WorkSans"),
                    ),
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
