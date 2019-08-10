import 'package:advance/components/workout.dart';
import 'package:advance/components/workout_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villain.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../styleguide.dart';

class WorkoutResultsLevelScreen extends StatefulWidget {
  final WorkoutArea workoutArea;
  final Workout workout;

  WorkoutResultsLevelScreen({Key key, this.workoutArea, this.workout})
      : super(key: key);

  @override
  _WorkoutResultsLevelScreenState createState() =>
      _WorkoutResultsLevelScreenState();
}

class _WorkoutResultsLevelScreenState extends State<WorkoutResultsLevelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Hero(
            tag: "background-${widget.workoutArea.title}",
            child: DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: widget.workoutArea.gradientColors,
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
                    "Experience",
                    style: AppTheme.heading,
                  ),
                  backgroundColor: Colors.transparent,
                  leading: Container(),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: CircularPercentIndicator(
                      reverse: true,
                      radius: 200,
                      lineWidth: 20,
                      animation: true,
                      percent: 0.5,
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.white,
                      footer: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text("+20 XP", style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: "WorkSans",
                          fontWeight: FontWeight.w700
                        ),),
                      ),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Center(
                  child: Text(
                    "Keep training to level up your workouts!",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "WorkSans",
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: RaisedButton(
                  elevation: 8,
                  color: Colors.white,
                  textColor: widget.workoutArea.getButtonColor(),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 22),
                  onPressed: () {Navigator.of(context).pop();},
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
    ));
  }
}
