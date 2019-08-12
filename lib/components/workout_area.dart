import 'package:advance/components/exercise.dart';
import 'package:advance/components/workout.dart';

List<WorkoutArea> workoutAreas = [
  WorkoutArea(
    id: 1,
    title: 'Arms',
    description: 'Blahhhhhhhhh blahalhhh',
    workouts: [
      Workout(
          1,
          "General",
          Duration(seconds: 10),
          Difficulty.easy,
          [
            Rest(Duration(seconds: 3)),
            TimedSet('Push ups', Duration(seconds: 3)),
            RepSet('Sit ups', 5)
          ],
          1),
      Workout(
          2,
          "General",
          Duration(seconds: 10),
          Difficulty.easy,
          [
            Rest(Duration(seconds: 5)),
            TimedSet('Push ups', Duration(seconds: 5))
          ],
          5)
    ],
    imagePath: 'assets/workout_cards/arm.png',
  ),
  WorkoutArea(
    id: 2,
    title: 'Back',
    description: 'Blahhhhhhhhh blahalhhh',
    workouts: [
      Workout(
          4,
          "General",
          Duration(seconds: 10),
          Difficulty.easy,
          [
            Rest(Duration(seconds: 5)),
            TimedSet('Push ups', Duration(minutes: 1))
          ],
          1),
      Workout(
          5,
          "General",
          Duration(seconds: 10),
          Difficulty.easy,
          [
            Rest(Duration(seconds: 5)),
            TimedSet('Push ups', Duration(minutes: 1))
          ],
          6)
    ],
    imagePath: 'assets/workout_cards/back.png',
    //gradientColors: [Colors.blue.shade400, Colors.lightBlue.shade200],
  ),
];

class WorkoutArea {
  final int id;
  String title;
  String description;
  List<Workout> workouts;
  String imagePath;

  WorkoutArea(
      {this.id, this.title, this.description, this.workouts, this.imagePath});
}
