import 'package:advance/components/exercise.dart';
import 'package:advance/components/user.dart';
import 'package:advance/screens/workout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:quiver/async.dart';

import '../styleguide.dart';

class TimedSetScreen extends StatefulWidget {
  TimedSetScreen({Key key}) : super(key: key);

  @override
  _TimedSetScreenState createState() => _TimedSetScreenState();
}

class _TimedSetScreenState extends State<TimedSetScreen>
    with SingleTickerProviderStateMixin {
  double _countdown;
  bool _isPaused;
  double _workoutStepCountdown;
  bool _workoutStepStarted;
  CountdownTimer _workoutCountdownTimer;

  int _currentScreenIndex;

  AnimationController _controller;
  Animation<double> _opacity;

  @override
  void initState() {
    _isPaused = false;
    _workoutStepStarted = true;
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.0, 0.6, curve: Curves.ease)));
    _controller.forward().orCancel;
    _workoutStepStarted = false;
    super.initState();
  }

  void _startTimedSetTimer(TimedSet timedSet, {double resumeAt}) {
    WorkoutController workoutController =
        Provider.of<WorkoutController>(context);
    _countdown = resumeAt ?? timedSet.duration.inSeconds.toDouble();
    _workoutCountdownTimer = CountdownTimer(
        Duration(seconds: _countdown.round()), Duration(milliseconds: 1));

    var sub = _workoutCountdownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _workoutStepCountdown =
            _countdown - duration.elapsed.inMilliseconds / 1000;
      });
    });

    sub.onDone(() async {
      if (_workoutStepCountdown.round() <= 0) {
        final nextStep = await workoutController.beginNextWorkoutStep();
        await _controller.reverse();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => nextStep));
      }
      sub.cancel();
    });
  }

  void _pauseTimer() {
    setState(() {
      _isPaused = true;
    });
    _workoutCountdownTimer.cancel();
  }

  void _resumeTimer(WorkoutStep workoutStep) {
    _isPaused = false;
    _startTimedSetTimer(workoutStep, resumeAt: _workoutStepCountdown);
  }

  @override
  void dispose() {
    _workoutCountdownTimer.cancel();
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
    if (!_workoutStepStarted) {
      _startTimedSetTimer(
          workoutController.getWorkoutStepAtIndex(_currentScreenIndex));
      _workoutStepStarted = true;
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
                  actions: <Widget>[
                    workoutController
                                .workout
                                .workoutSteps[
                                    workoutController.currentWorkoutStepIndex]
                                .videoId !=
                            null
                        ? Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: IconButton(
                              onPressed: () {
                                return FlutterYoutube.playYoutubeVideoById(
                                    apiKey:
                                        'AIzaSyB5iSZcVN5BGHnHSnRuHSOZ5wVkfFqrghA',
                                    videoId:
                                            workoutController
                                                .workout
                                                .workoutSteps[workoutController
                                                    .currentWorkoutStepIndex]
                                                .videoId,
                                    autoPlay: true,
                                    fullScreen: false);
                              },
                              color: Colors.white,
                              icon: Icon(Icons.videocam),
                              iconSize: 40,
                            ),
                          )
                        : Container()
                  ],
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
                        Navigator.pop(context, false);
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
                      percent: (((_workoutStepCountdown != null &&
                                  _workoutStepCountdown >= 0)
                              ? _workoutStepCountdown
                              : 0) /
                          (workoutController.getWorkoutStepAtIndex(
                                  _currentScreenIndex) as TimedSet)
                              .duration
                              .inSeconds),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.white,
                      center: Text(
                        _workoutStepCountdown != null
                            ? _workoutStepCountdown.ceil().toString()
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
                      padding:
                          EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Hero(
                            tag: 'backward',
                            child: GestureDetector(
                              onTap: () async {
                                _workoutCountdownTimer.cancel();
                                final previousStep = await workoutController
                                    .beginPreviousWorkoutStep();
                                return Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
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
                                    ? _resumeTimer(
                                        workoutController.getWorkoutStepAtIndex(
                                            _currentScreenIndex))
                                    : _pauseTimer();
                              },
                              child: Text(
                                _isPaused ? "Resume" : "Pause",
                                style: TextStyle(
                                    fontSize: 20, fontFamily: "WorkSans"),
                              ),
                              shape: new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                            ),
                          ),
                          Hero(
                            tag: 'forward',
                            child: GestureDetector(
                              onTap: () async {
                                _workoutCountdownTimer.cancel();
                                final nextStep = await workoutController
                                    .beginNextWorkoutStep();
                                return Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
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
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(5)),
                                  color: index <=
                                          workoutController
                                              .currentWorkoutStepIndex
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
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
