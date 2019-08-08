import 'dart:async';
import 'package:advance/components/exercise.dart';
import 'package:advance/components/workout.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  Workout workout;
  int _currentWorkoutStepIndex = 0;

  WorkoutBloc(this.workout);

  @override
  WorkoutState get initialState => InitialWorkoutState();

  @override
  Stream<WorkoutState> mapEventToState(
    WorkoutEvent event,
  ) async* {
    if (event is BeginNextWorkoutStep) {
      if (_currentWorkoutStepIndex < workout.workoutSteps.length) {
        final nextStep = workout.workoutSteps[_currentWorkoutStepIndex];
        if (nextStep is TimedSet) {
          yield RunningTimedSet(nextStep);
        } else if (nextStep is RepSet) {
          yield RunningRepSet(nextStep);
        } else if (nextStep is Rest) {
          yield RunningRest(nextStep);
        }
      } else {
        yield FinishedWorkout();
      }
    } else if (event is FinishWorkoutStep) {
      _currentWorkoutStepIndex += 1;
      dispatch(BeginNextWorkoutStep());
    }
  }
}
