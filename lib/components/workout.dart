import 'package:advance/components/exercise.dart';

class Workout {
  String title;
  Duration duration;
  Difficulty difficulty;
  List<WorkoutStep> workoutSteps;
  int requiredLevel;

  Workout(this.title, this.duration, this.difficulty, this.workoutSteps, this.requiredLevel);

  String getDifficultyString() => difficulty.toString().split('.').last;
}

enum Difficulty {
  easy,
  medium,
  hard,
  master,
}
