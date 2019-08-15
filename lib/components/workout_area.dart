import 'package:advance/components/workout.dart';

class WorkoutArea {
  String slug;
  String title;
  String description;
  List<Workout> workouts;
  String imagePath;

  factory WorkoutArea.fromConfig(String slug, Map data, Map<String, Workout> workouts) {
    return WorkoutArea(
      slug: slug,
      title: data['title'],
      description: data['description'],
      workouts:
          (data['workouts'] as List<dynamic>).map((k) => workouts[k]).toList(),
      imagePath: data['image_path'],
    );
  }

  WorkoutArea(
      {this.slug, this.title, this.description, this.workouts, this.imagePath});
}

//gradientColors: [Colors.blue.shade400, Colors.lightBlue.shade200],
