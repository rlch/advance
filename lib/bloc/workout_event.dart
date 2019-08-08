import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WorkoutEvent extends Equatable {
  WorkoutEvent([List props = const []]) : super(props);
}

class BeginNextWorkoutStep extends WorkoutEvent {

}

class FinishWorkoutStep extends WorkoutEvent {

}