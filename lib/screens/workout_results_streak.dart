import 'package:advance/components/streak_chart.dart';
import 'package:advance/components/user.dart';
import 'package:advance/components/workout.dart';
import 'package:advance/components/workout_area.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villain.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../styleguide.dart';

class WorkoutResultsStreakScreen extends StatefulWidget {
  final WorkoutArea workoutArea;
  final Workout workout;

  WorkoutResultsStreakScreen({Key key, this.workoutArea, this.workout})
      : super(key: key);

  @override
  _WorkoutResultsStreakScreenState createState() =>
      _WorkoutResultsStreakScreenState();
}

class _WorkoutResultsStreakScreenState
    extends State<WorkoutResultsStreakScreen> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    final screenHeight = MediaQuery.of(context).size.width;
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
                Villain(
                  villainAnimation: VillainAnimation.fade(
                      from: Duration(milliseconds: 0),
                      to: Duration(milliseconds: 1000),
                      fadeFrom: 0,
                      fadeTo: 1,
                      curve: Curves.linear),
                  animateExit: true,
                  animateEntrance: true,
                  child: AppBar(
                    elevation: 0.0,
                    centerTitle: true,
                    title: Text(
                      "Streak",
                      style: AppTheme.heading,
                    ),
                    backgroundColor: Colors.transparent,
                    leading: Container(),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: CircularPercentIndicator(
                      reverse: true,
                      radius: screenHeight * 0.4,
                      lineWidth: 18,
                      animation: true,
                      percent: 0.5,
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.white,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "2",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 45,
                            ),
                          ),
                          Text(
                            "days",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: screenHeight * 0.65,
                  child: StreakChart(
                    themeColor: user.appTheme.themeColor.primary,
                  ),
                ),
                Expanded(
                    child: AutoSizeText(
                  "Train every day to maintain your streak!",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "WorkSans",
                      fontSize: 18,
                      color: Colors.white),
                )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: RaisedButton(
                    elevation: 8,
                    color: Colors.white,
                    textColor: user.appTheme.themeColor.primary,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 22),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
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
