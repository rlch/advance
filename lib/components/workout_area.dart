import 'package:advance/components/workout.dart';
import 'package:slugify/slugify.dart';

class WorkoutArea {
  String get slug {
    return Slugify(title, delimiter: '_');
  }

  String title;
  String description;
  List<Workout> workouts;
  String imagePath;

  factory WorkoutArea.fromConfig(Map data, Map<String, Workout> workouts) {
    return WorkoutArea(
      title: data['title'],
      description: data['description'],
      workouts:
          (data['workouts'] as List<dynamic>).map((k) => workouts[k]).toList(),
      imagePath: data['image_path'],
    );
  }

  WorkoutArea(
      {this.title, this.description, this.workouts, this.imagePath});
}

//gradientColors: [Colors.blue.shade400, Colors.lightBlue.shade200],
