import 'package:advance/components/exercise.dart';
import 'package:advance/components/user.dart';
import 'package:advance/components/workout.dart';
import 'package:advance/firebase/user_service.dart';
import 'package:advance/screens/rest.dart';
import 'package:advance/screens/timed_set.dart';
import 'package:advance/screens/workout_results_ad.dart';
import 'package:advance/screens/workout_results_level.dart';
import 'package:advance/screens/workout_results_streak.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quiver/async.dart';

import 'package:advance/components/workout_area.dart';
import 'package:flutter/material.dart';
import 'rep_set.dart';

class WorkoutController {
  int currentWorkoutStepIndex;
  WorkoutStep _currentWorkoutStep;
  final Workout workout;
  final WorkoutArea workoutArea;
  final User user;
  WorkoutController(this.workout, this.user, {this.workoutArea}) {
    this._currentWorkoutStep = workout.workoutSteps[0];
  }

  List<Widget> finishSteps;
  int finishIndex;

  Widget _provider(Widget child) {
    return Provider.value(
      value: this,
      child: child,
    );
  }

  Future<Widget> beginNextWorkoutStep() async {
    if (currentWorkoutStepIndex == null) {
      currentWorkoutStepIndex = 0;
    } else {
      currentWorkoutStepIndex += 1;
    }
    if (currentWorkoutStepIndex < workout.workoutSteps.length) {
      _currentWorkoutStep = workout.workoutSteps[currentWorkoutStepIndex];
      if (_currentWorkoutStep is TimedSet) {
        return _provider(TimedSetScreen());
      } else if (_currentWorkoutStep is RepSet) {
        return _provider(RepSetScreen());
      } else if (_currentWorkoutStep is Rest) {
        return _provider(RestScreen());
      }
    } else {
      if (workoutArea != null) {
        finishSteps = [
          _provider(WorkoutResultsStreakScreen()),
          _provider(WorkoutResultsLevelScreen()),
          _provider(WorkoutResultsAdScreen())
        ];
      } else {
        finishSteps = [_provider(WorkoutResultsAdScreen())];
      }

      if (workoutArea != null) {
        updateLocalStats();
        await UserService()
            .updateWorkoutResults(user.firebaseUser.uid, workout, workoutArea);
      }

      return beginNextFinishWorkoutStep();
    }
    return null;
  }

  void updateLocalStats() {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    DateFormat format = DateFormat('dd-MM-yyyy');

    final history = user.streak.history.update(
        format.format(date),
        (history) => UserStreakHistory(
            history.date,
            history.experience + workout.experience,
            history.workoutsCompleted + 1),
        ifAbsent: () => UserStreakHistory(date, workout.experience, 1));
    if (history.workoutsCompleted == user.streak.target) {
      user.streak.current += 1;
    }

    user.workouts[workoutArea.slug].exercises
        .updateAll((id, exercise) => UserExercise(exercise.timesCompleted + 1));
    user.workouts[workoutArea.slug].experience.amount += workout.experience;
  }

  WorkoutStep getWorkoutStepAtIndex(int index) {
    return workout.workoutSteps[index];
  }

  Widget beginNextFinishWorkoutStep() {
    if (finishIndex == null) {
      finishIndex = 0;
      return finishSteps[0];
    } else if (finishIndex < finishSteps.length) {
      finishIndex += 1;
      return finishSteps[finishIndex];
    }
    return null;
  }
}

class WorkoutCountdownScreen extends StatefulWidget {
  final Workout workout;
  final WorkoutArea workoutArea;

  WorkoutCountdownScreen(this.workout, {this.workoutArea, Key key})
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

    _countdownTimer.listen((duration) {
      setState(() {
        _countdown = 3 - duration.elapsed.inSeconds;
        _countdownAnimationController.reset();
        _countdownAnimationController.forward();
      });
    }, onDone: () async {
      WorkoutController _workoutController = WorkoutController(
          widget.workout, Provider.of<User>(context),
          workoutArea: widget.workoutArea);
      final nextStep = await _workoutController.beginNextWorkoutStep();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => nextStep));
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
            tag: widget.workoutArea == null
                ? 'workout-custom'
                : "background-${widget.workoutArea.title}",
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
