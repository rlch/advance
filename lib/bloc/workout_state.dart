import 'package:advance/components/exercise.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WorkoutState {
  WorkoutState([List props = const []]);
}

class InitialWorkoutState extends WorkoutState {}

class FinishedWorkout extends WorkoutState {}

class RunningTimedSet extends WorkoutState {
  final TimedSet timedSet;

  RunningTimedSet(this.timedSet);
}

class RunningRepSet extends WorkoutState {
  final RepSet repSet;

  RunningRepSet(this.repSet);
}

class RunningRest extends WorkoutState {
  final Rest rest;

  RunningRest(this.rest);
}