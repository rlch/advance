import 'package:advance/components/user.dart';
import 'package:advance/components/workout.dart';
import 'package:advance/screens/rest.dart';
import 'package:advance/screens/timed_set.dart';
import 'package:advance/screens/workout_results_level.dart';
import 'package:advance/screens/workout_results_streak.dart';
import 'package:provider/provider.dart';
import 'package:quiver/async.dart';

import 'package:advance/bloc/bloc.dart';
import 'package:advance/bloc/workout_bloc.dart';
import 'package:advance/components/workout_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'rep_set.dart';

class WorkoutCountdownScreen extends StatefulWidget {
  final Workout workout;
  final WorkoutArea workoutArea;

  WorkoutCountdownScreen(this.workout, this.workoutArea, {Key key})
      : super(key: key);

  @override
  _WorkoutCountdownScreenState createState() => _WorkoutCountdownScreenState();
}

class _WorkoutCountdownScreenState extends State<WorkoutCountdownScreen>
    with TickerProviderStateMixin {
  int _countdown;
  AnimationController _countdownAnimationController;
  Animation<double> _countdownAnimation;
  CountdownTimer _workoutCountdownTimer;

  void _startCountdown() {
    _countdown = 3;

    CountdownTimer _countdownTimer =
        CountdownTimer(Duration(seconds: 3), Duration(seconds: 1));

    var sub = _countdownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _countdown = 3 - duration.elapsed.inSeconds;
        _countdownAnimationController.reset();
        _countdownAnimationController.forward();
      });
    });

    sub.onDone(() async {
      sub.cancel();
      await Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, _, __) => BlocProvider(
              builder: (BuildContext context) => WorkoutBloc(widget.workout),
              child: WorkoutScreen(widget.workout, widget.workoutArea))));
      Navigator.of(context).pop();
    });
  }

  @override
  void initState() {
    _countdownAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _countdownAnimation = CurvedAnimation(
        parent: _countdownAnimationController, curve: Curves.bounceInOut);
    _startCountdown();
    _countdownAnimationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _workoutCountdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
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
        Center(
          child: ScaleTransition(
            scale: _countdownAnimation,
            child: Text(
              "$_countdown",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 80,
                  fontWeight: FontWeight.w600),
            ),
          ),
        )
      ],
    ));
  }
}

class WorkoutScreen extends StatefulWidget {
  final Workout workout;
  final WorkoutArea workoutArea;
  WorkoutScreen(this.workout, this.workoutArea, {Key key}) : super(key: key);

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>
    with TickerProviderStateMixin {
  WorkoutBloc _workoutBloc;

  @override
  void initState() {
    print("init workoutscreen");
    _workoutBloc = BlocProvider.of<WorkoutBloc>(context);
    _workoutBloc.dispatch(BeginNextWorkoutStep());
    super.initState();
  }

  @override
  void dispose() {
    _workoutBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider<WorkoutBloc>.value(
        value: _workoutBloc,
        child: BlocListener(
            bloc: _workoutBloc,
            listener: (listenerContext, state) async {
              if (state is RunningTimedSet) {
                await Navigator.push(
                    listenerContext,
                    PageRouteBuilder(
                        pageBuilder: (listenerContext, _, __) => TimedSetScreen(
                              timedSet: state.timedSet,
                              workoutArea: widget.workoutArea,
                            ))).then((result) => result
                    ? _workoutBloc.dispatch(FinishWorkoutStep())
                    : Navigator.of(context).pop(false));
              } else if (state is RunningRepSet) {
                await Navigator.push(
                    listenerContext,
                    PageRouteBuilder(
                        pageBuilder: (listenerContext, _, __) => RepSetScreen(
                            repSet: state.repSet,
                            workoutArea: widget.workoutArea))).then((result) =>
                    result
                        ? _workoutBloc.dispatch(FinishWorkoutStep())
                        : Navigator.of(context).pop(false));
              } else if (state is RunningRest) {
                await Navigator.push(
                    listenerContext,
                    PageRouteBuilder(
                        pageBuilder: (listenerContext, _, __) => RestScreen(
                              rest: state.rest,
                              workoutArea: widget.workoutArea,
                            ))).then((result) => result
                    ? _workoutBloc.dispatch(FinishWorkoutStep())
                    : Navigator.of(context).pop(false));
              } else if (state is FinishedWorkout) {
                await Navigator.push(
                    listenerContext,
                    PageRouteBuilder(
                        pageBuilder: (listenerContext, _, __) =>
                            WorkoutResultsStreakScreen(
                                workoutArea: widget.workoutArea,
                                workout: widget.workout)));
                await Navigator.push(
                    listenerContext,
                    PageRouteBuilder(
                        pageBuilder: (listenerContext, _, __) =>
                            WorkoutResultsLevelScreen(
                                workoutArea: widget.workoutArea,
                                workout: widget.workout)));
                Navigator.of(context).pop();
              }
            },
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
              ],
            ))),
      ),
    );
  }
}
