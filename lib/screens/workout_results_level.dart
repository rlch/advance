import 'package:advance/components/user.dart';
import 'package:advance/screens/workout.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../styleguide.dart';

class WorkoutResultsLevelScreen extends StatefulWidget {
  WorkoutResultsLevelScreen({Key key}) : super(key: key);

  @override
  _WorkoutResultsLevelScreenState createState() =>
      _WorkoutResultsLevelScreenState();
}

class _WorkoutResultsLevelScreenState extends State<WorkoutResultsLevelScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _opacity;

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.0, 0.6, curve: Curves.ease)));
    _controller.forward().orCancel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    WorkoutController workoutController =
        Provider.of<WorkoutController>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
              tag: "background-${workoutController.workoutArea.title}",
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
                  title: Hero(
                    tag: 'workout-title',
                    flightShuttleBuilder: (BuildContext flightContext,
                            Animation<double> animation,
                            HeroFlightDirection flightDirection,
                            BuildContext fromHeroContext,
                            BuildContext toHeroContext) =>
                        Material(
                            color: Colors.transparent,
                            child: toHeroContext.widget),
                    child: Text(
                      "Experience",
                      style: AppTheme.heading,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  leading: Container(),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: FadeTransition(
                        opacity: _opacity,
                        child: CircularPercentIndicator(
                          reverse: true,
                          radius: 200,
                          lineWidth: 20,
                          animation: true,
                          percent: user
                              .workouts[workoutController.workoutArea.slug]
                              .experience
                              .progress,
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.white,
                          footer: Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Text(
                              "+${workoutController.workout.experience.round()} XP",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontFamily: "WorkSans",
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                user.workouts[workoutController.workoutArea.slug]
                                    .experience.level
                                    .toString(),
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
                ),
                FadeTransition(
                  opacity: _opacity,
                  child: Padding(
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
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Hero(
                    tag: 'workout-button',
                    child: RaisedButton(
                      elevation: 8,
                      color: Colors.white,
                      textColor: user.appTheme.themeColor.primary,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 22),
                      onPressed: () async {
                        await _controller.reverse();
                        Widget redirect =
                            workoutController.beginNextFinishWorkoutStep();
                        if (redirect != null) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) => redirect));
                        }
                      },
                      child: Text(
                        "Continue",
                        style: TextStyle(fontSize: 20, fontFamily: "WorkSans"),
                      ),
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                    ),
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
