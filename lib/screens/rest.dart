import 'package:advance/components/exercise.dart';
import 'package:advance/components/user.dart';
import 'package:advance/screens/workout.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:quiver/async.dart';

import '../styleguide.dart';

class RestScreen extends StatefulWidget {
  RestScreen({Key key}) : super(key: key);

  @override
  _RestScreenState createState() => _RestScreenState();
}

class _RestScreenState extends State<RestScreen>
    with SingleTickerProviderStateMixin {
  int _countdown;
  bool _isPaused = false;
  double _restCountdown;
  bool _restStarted;
  CountdownTimer _restCountdownTimer;

  AnimationController _controller;
  Animation<double> _opacity;

  int _currentScreenIndex;

  @override
  void initState() {
    _restStarted = true;
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.0, 0.6, curve: Curves.ease)));
    _controller.forward().orCancel;
    _restStarted = false;
    super.initState();
  }

  void _startRestTimer(Rest rest, {double resumeAt}) {
    WorkoutController workoutController =
        Provider.of<WorkoutController>(context);
    _countdown = rest.duration.inSeconds;
    _restCountdownTimer = CountdownTimer(
        Duration(seconds: _countdown), Duration(milliseconds: 1));

    _restCountdownTimer.listen((duration) {
      setState(() {
        if (resumeAt == null) {
          _restCountdown =
              rest.duration.inSeconds - duration.elapsed.inMilliseconds / 1000;
        } else {
          _restCountdown = resumeAt - duration.elapsed.inMilliseconds / 1000;
        }
      });
    }, onDone: () async {
      if (_restCountdown.round() <= 0) {
        final nextStep = await workoutController.beginNextWorkoutStep();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => nextStep));
      }
    });
  }

  void _pauseRestTimer() {
    setState(() {
      _isPaused = true;
    });
    _restCountdownTimer.cancel();
  }

  void _resumeRestTimer(Rest rest) {
    _isPaused = false;
    _startRestTimer(rest, resumeAt: _restCountdown);
  }

  @override
  void dispose() async {
    _restCountdownTimer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    WorkoutController workoutController =
        Provider.of<WorkoutController>(context);

    if (_currentScreenIndex == null) {
      _currentScreenIndex = workoutController.currentWorkoutStepIndex;
    }

    if (!_restStarted) {
      _startRestTimer(
          workoutController.getWorkoutStepAtIndex(_currentScreenIndex));
      _restStarted = true;
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
              tag: workoutController.workoutArea == null
                  ? 'workout-custom'
                  : "background-${workoutController.workoutArea.title}",
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
                      workoutController
                          .getWorkoutStepAtIndex(_currentScreenIndex)
                          .title,
                      style: AppTheme.heading,
                    ),
                  ),
                  leading: Hero(
                    flightShuttleBuilder: (BuildContext flightContext,
                            Animation<double> animation,
                            HeroFlightDirection flightDirection,
                            BuildContext fromHeroContext,
                            BuildContext toHeroContext) =>
                        Material(
                            color: Colors.transparent,
                            child: toHeroContext.widget),
                    tag: 'close',
                    child: IconButton(
                      iconSize: 40,
                      icon: Icon(Icons.close),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                ),
                FadeTransition(
                  opacity: _opacity,
                  child: Center(
                    child: CircularPercentIndicator(
                      reverse: true,
                      radius: 200,
                      lineWidth: 20,
                      animation: false,
                      percent: (((_restCountdown != null && _restCountdown >= 0)
                              ? _restCountdown
                              : 0) /
                          (workoutController.getWorkoutStepAtIndex(
                                  _currentScreenIndex) as Rest)
                              .duration
                              .inSeconds),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.white,
                      center: Text(
                        _restCountdown != null
                            ? _restCountdown.ceil().toString()
                            : "",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontFamily: "WorkSans",
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Hero(
                            tag: 'backward',
                            child: GestureDetector(
                              onTap: () async {
                                _restCountdownTimer.cancel();
                                final previousStep = await workoutController
                                    .beginPreviousWorkoutStep();
                                return Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(builder: (context) {
                                  return previousStep;
                                }));
                              },
                              child: Icon(
                                Icons.keyboard_arrow_left,
                                size: 45,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Hero(
                            tag: 'workout-button',
                            child: RaisedButton(
                              elevation: 8,
                              color: Colors.white,
                              textColor: user.appTheme.themeColor.primary,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 22),
                              onPressed: () {
                                _isPaused
                                    ? _resumeRestTimer(workoutController
                                        .getWorkoutStepAtIndex(_currentScreenIndex))
                                    : _pauseRestTimer();
                              },
                              child: Text(
                                _isPaused ? "Resume" : "Pause",
                                style:
                                    TextStyle(fontSize: 20, fontFamily: "WorkSans"),
                              ),
                              shape: new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                            ),
                          ),
                          Hero(
                            tag: 'forward',
                            child: GestureDetector(
                              onTap: () async {
                                _restCountdownTimer.cancel();
                                final nextStep =
                                    await workoutController.beginNextWorkoutStep();
                                return Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(builder: (context) {
                                  return nextStep;
                                }));
                              },
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                size: 45,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Hero(
                      tag: 'timeline',
                                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                            workoutController.workout.workoutSteps.length,
                            (index) {
                          return Flexible(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                                  color: index <=
                                        workoutController.currentWorkoutStepIndex
                                    ? Colors.white
                                    : Colors.black.withOpacity(0.3),
                                ),
                                height: 10,
                              ),
                            ),
                          );
                        }),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
