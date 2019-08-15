import 'package:advance/components/exercise.dart';

class Workout {
  String slug;
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

  factory Workout.custom(String slug, String title, List<Map<String, dynamic>> workoutSteps) {
    WorkoutStep _buildWorkoutStep(Map<dynamic, dynamic> step) {
      switch (step['type']) {
        case "timed_set":
          return TimedSet(title, Duration(seconds: step['duration']));
        case "rep_set":
          return RepSet(title, step['reps']);
        case "rest":
          return Rest(Duration(seconds: step['duration']));
      }
      return null;
    }
    
    return Workout(
      slug,
      title,
      workoutSteps.map((step) => _buildWorkoutStep(step)).toList(),
    );
  }

  factory Workout.fromConfig(String slug, Map data, Map<String, WorkoutStep> workoutSteps) {

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

    return Workout(
      slug,
      data['title'],
      (data['workout_steps'] as List<dynamic>).map((step) => _buildWorkoutStep(step as Map<dynamic, dynamic>)).toList(),
      difficulty: _difficultyFromString(data['difficulty']),
      requiredLevel: data['required_level'],
    );
  }

  Workout(this.slug, this.title, this.workoutSteps, {this.difficulty,
      this.requiredLevel});

  String getDifficultyString() => difficulty.toString().split('.').last;
}

enum Difficulty {
  easy,
  medium,
  hard,
  master,
}
