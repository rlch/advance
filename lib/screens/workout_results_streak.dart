import 'package:advance/components/streak_chart.dart';
import 'package:advance/components/user.dart';
import 'package:advance/screens/workout.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../styleguide.dart';

class WorkoutResultsStreakScreen extends StatefulWidget {
  WorkoutResultsStreakScreen({Key key}) : super(key: key);

  @override
  _WorkoutResultsStreakScreenState createState() =>
      _WorkoutResultsStreakScreenState();
}

class _WorkoutResultsStreakScreenState extends State<WorkoutResultsStreakScreen>
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
    final screenHeight = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    DateFormat format = DateFormat('dd-MM-yyyy');
    final formatted = format.format(date);

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
                      "Streak",
                      style: AppTheme.heading,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  leading: Container(),
                ),
                FadeTransition(
                  opacity: _opacity,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: CircularPercentIndicator(
                        reverse: true,
                        radius: screenHeight * 0.4,
                        lineWidth: 18,
                        animation: true,
                        percent: ((user.streak.history[formatted]
                                        .workoutsCompleted) /
                                    user.streak.target <=
                                1)
                            ? (user.streak.history[formatted]
                                    .workoutsCompleted) /
                                user.streak.target
                            : 1.0,
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.white,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              user.streak.current.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 45,
                              ),
                            ),
                            Text(
                              Intl.plural(user.streak.current,
                                  other: 'days', one: 'day'),
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
                ),
                FadeTransition(
                  opacity: _opacity,
                  child: Container(
                    height: screenHeight * 0.65,
                    child: StreakChart(
                      history: user.streak.history,
                      themeColor: user.appTheme.themeColor.primary,
                    ),
                  ),
                ),
                Expanded(
                    child: FadeTransition(
                  opacity: _opacity,
                  child: AutoSizeText(
                    "Train every day to maintain your streak!",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "WorkSans",
                        fontSize: 18,
                        color: Colors.white),
                  ),
                )),
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
