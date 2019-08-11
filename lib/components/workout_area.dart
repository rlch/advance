import 'package:advance/components/exercise.dart';
import 'package:advance/components/workout.dart';
import 'package:flutter/material.dart';

import 'experience.dart';

List<WorkoutArea> workoutAreas = [
  WorkoutArea(
      title: 'Arms',
      description: 'Blahhhhhhhhh blahalhhh',
      workouts: [
        Workout(
            "General",
            Duration(seconds: 10),
            Difficulty.easy,
            [
              Rest(Duration(seconds: 3)),
              TimedSet('Push ups', Duration(seconds: 3)),
              RepSet('Sit ups', 5)
            ],
            2),
        Workout(
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
      gradientColors: [Colors.pink.shade200, Colors.redAccent.shade400],
      experience: Experience(470)),
  WorkoutArea(
      title: 'Back',
      description: 'Blahhhhhhhhh blahalhhh',
      workouts: [
        Workout(
            "General",
            Duration(seconds: 10),
            Difficulty.easy,
            [
              Rest(Duration(seconds: 5)),
              TimedSet('Push ups', Duration(minutes: 1))
            ],
            1),
        Workout(
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
      gradientColors: [Colors.blue.shade400, Colors.lightBlue.shade200],
      experience: Experience(900)),
];

class WorkoutArea {
  final int id;
  String title;
  String description;
  List<Workout> workouts;
  String imagePath;
  List<Color> gradientColors;
  Experience experience;

  WorkoutArea(
      {this.id,
      this.title,
      this.description,
      this.workouts,
      this.imagePath,
      this.gradientColors,
      this.experience});

  Color getButtonColor() {
    final red = (gradientColors[0].red + gradientColors[1].red) ~/ 2;
    final green = (gradientColors[0].green + gradientColors[1].green) ~/ 2;
    final blue = (gradientColors[0].blue + gradientColors[1].blue) ~/ 2;
    return Color.fromRGBO(red, green, blue, 1.0);
  }
}
