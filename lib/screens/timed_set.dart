import 'package:advance/components/exercise.dart';
import 'package:advance/components/user.dart';
import 'package:advance/components/workout_area.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:quiver/async.dart';

import '../styleguide.dart';

class TimedSetScreen extends StatefulWidget {
  final WorkoutArea workoutArea;
  final TimedSet timedSet;
  TimedSetScreen({Key key, this.workoutArea, this.timedSet}) : super(key: key);

  @override
  _TimedSetScreenState createState() => _TimedSetScreenState();
}

class _TimedSetScreenState extends State<TimedSetScreen> {
  int _countdown;
  bool _isPaused;
  double _workoutStepCountdown;
  bool _workoutStepStarted;
  CountdownTimer _workoutCountdownTimer;

  @override
  void initState() {
    _isPaused = false;
    _workoutStepStarted = false;
    super.initState();
  }

  void _startTimedSetTimer(TimedSet timedSet, {double resumeAt}) {
    _countdown = timedSet.duration.inSeconds;
    _workoutCountdownTimer = CountdownTimer(
        Duration(seconds: _countdown), Duration(milliseconds: 1));

    var sub = _workoutCountdownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        if (resumeAt == null) {
          _workoutStepCountdown = timedSet.duration.inSeconds -
              duration.elapsed.inMilliseconds / 1000;
        } else {
          _workoutStepCountdown =
              resumeAt - duration.elapsed.inMilliseconds / 1000;
        }
      });
    });

    sub.onDone(() {
      if (_workoutStepCountdown.round() == 0) {
        Navigator.pop(context, true);
      }
      sub.cancel();
    });
  }

  void _pauseTimer() {
    _isPaused = true;
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
    if (!_workoutStepStarted) {
      _startTimedSetTimer(widget.timedSet);
      _workoutStepStarted = true;
    }
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
                    widget.timedSet.title,
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
                  child: CircularPercentIndicator(
                    reverse: true,
                    radius: 200,
                    lineWidth: 20,
                    animation: false,
                    percent: (((_workoutStepCountdown != null &&
                                _workoutStepCountdown >= 0)
                            ? _workoutStepCountdown
                            : 0) /
                        widget.timedSet.duration.inSeconds),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: RaisedButton(
                    elevation: 8,
                    color: Colors.white,
                    textColor: user.appTheme.themeColor.primary,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 22),
                    onPressed: () {
                      _isPaused ? _resumeTimer(widget.timedSet) : _pauseTimer();
                    },
                    child: Text(
                      _isPaused ? "Resume" : "Pause",
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
