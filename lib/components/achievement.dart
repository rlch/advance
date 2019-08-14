import 'package:slugify/slugify.dart';

class Achievement {
  String get slug {
    return Slugify(title, delimiter: '_');
  }
  String title;
  List<String> descriptions;
  List<int> goals;
  String iconPath;

  Achievement(
      {this.title, this.descriptions, this.goals, this.iconPath});

  factory Achievement.fromConfig(Map data) {
    return Achievement(
      title: data['title'],
      descriptions: (data['descriptions'] as List<dynamic>).cast<String>(),
      goals: (data['goals'] as List<dynamic>).cast<int>(),
      iconPath: data['icon_path']
    );
  }
}