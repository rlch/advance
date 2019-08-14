import 'package:advance/components/exercise.dart';

class Workout {
  int id;
  String title;
  Difficulty difficulty;
  List<WorkoutStep> workoutSteps;
  int requiredLevel;

  Duration get duration {
    Duration total = Duration(minutes: 0);
    for (final workoutStep in this.workoutSteps) {
      if (workoutStep is TimedSet) {
        total += workoutStep.duration;
      } else if (workoutStep is Rest) {
        total += workoutStep.duration;
      } else if (workoutStep is RepSet) {
        total += Duration(seconds: (5 * workoutStep.reps));
      }
    }
    return total;
  }

  double get experience {
    double base = duration.inSeconds / 15;
    switch (difficulty) {
      case Difficulty.easy:
        return base;
      case Difficulty.medium:
        return base * 1.2;
      case Difficulty.hard:
        return base * 1.5;
      case Difficulty.master:
        return base * 2;
    }
    return base;
  }

  factory Workout.fromConfig(Map data, Map<String, WorkoutStep> workoutSteps) {

    Difficulty _difficultyFromString(String difficulty) {
      switch (difficulty) {
        case 'easy':
          return Difficulty.easy;
        case 'medium':
          return Difficulty.medium;
        case 'hard':
          return Difficulty.hard;
        case 'master':
          return Difficulty.master;
      }
      return null;
    }

    WorkoutStep _buildWorkoutStep(Map<dynamic, dynamic> step) {
      switch (step['type']) {
        case "timed_set":
          return TimedSet.fromConfig(step, workoutSteps[step['slug']]);
        case "rep_set":
          return RepSet.fromConfig(step, workoutSteps[step['slug']]);
        case "rest":
          return Rest.fromConfig(step);
      }
      return null;
    }

    print(data['workout_steps']);

    return Workout(
      data['id'],
      data['title'],
      _difficultyFromString(data['difficulty']),
      (data['workout_steps'] as List<dynamic>).map((step) => _buildWorkoutStep(step as Map<dynamic, dynamic>)).toList(),
      data['required_level'],
    );
  }

  Workout(this.id, this.title, this.difficulty, this.workoutSteps,
      this.requiredLevel,);

  String getDifficultyString() => difficulty.toString().split('.').last;
}

enum Difficulty {
  easy,
  medium,
  hard,
  master,
}
