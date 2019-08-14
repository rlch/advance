import 'package:advance/components/workout.dart';

class WorkoutArea {
  final int id;
  String title;
  String description;
  List<Workout> workouts;
  String imagePath;

  factory WorkoutArea.fromConfig(Map data, Map<String, Workout> workouts) {
    return WorkoutArea(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      workouts: (data['workouts'] as List<dynamic>).map((k) => workouts[k]).toList(),
      imagePath: data['image_path'],
    );
  }

  WorkoutArea(
      {this.id, this.title, this.description, this.workouts, this.imagePath});
}

//gradientColors: [Colors.blue.shade400, Colors.lightBlue.shade200],