import 'package:advance/components/exercise.dart';
import 'package:advance/components/workout_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villain.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quiver/async.dart';

import '../styleguide.dart';

class RestScreen extends StatefulWidget {
  final WorkoutArea workoutArea;
  final Rest rest;
  RestScreen({Key key, this.workoutArea, this.rest}) : super(key: key);

  @override
  _RestScreenState createState() => _RestScreenState();
}

class _RestScreenState extends State<RestScreen> {
  int _countdown;
  bool _isPaused;
  double _restCountdown;
  bool _restStarted;
  CountdownTimer _restCountdownTimer;

  @override
  void initState() {
    print("init rest");
    _isPaused = false;
    _restStarted = false;
    super.initState();
  }

  void _startRestTimer(Rest rest, {double resumeAt}) {
    _countdown = rest.duration.inSeconds;
    _restCountdownTimer = CountdownTimer(
        Duration(seconds: _countdown), Duration(milliseconds: 1));

    var sub = _restCountdownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        if (resumeAt == null) {
          _restCountdown =
              rest.duration.inSeconds - duration.elapsed.inMilliseconds / 1000;
        } else {
          _restCountdown = resumeAt - duration.elapsed.inMilliseconds / 1000;
        }
      });
    });

    sub.onDone(() {
      if (_restCountdown.round() == 0) {
        Navigator.of(context).pop(true);
      }
      sub.cancel();
    });
  }

  void _pauseRestTimer() {
    _isPaused = true;
    _restCountdownTimer.cancel();
  }

  void _resumeRestTimer(Rest rest) {
    _isPaused = false;
    _startRestTimer(rest, resumeAt: _restCountdown);
  }

  @override
  void dispose() {
    _restCountdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_restStarted) {
      _startRestTimer(widget.rest);
      _restStarted = true;
    }
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
                    widget.rest.title,
                    style: AppTheme.heading,
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: IconButton(
                      iconSize: 40,
                      icon: Icon(Icons.close),
                      color: Colors.white.withOpacity(0.9),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
              Center(
                child: CircularPercentIndicator(
                  reverse: true,
                  radius: 200,
                  lineWidth: 20,
                  animation: false,
                  percent:
                      ((_restCountdown ?? 0) / widget.rest.duration.inSeconds),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: RaisedButton(
                  elevation: 8,
                  color: Colors.white,
                  textColor: widget.workoutArea.getButtonColor(),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 22),
                  onPressed: () {
                    _isPaused
                        ? _resumeRestTimer(widget.rest)
                        : _pauseRestTimer();
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
    ));
  }
}
