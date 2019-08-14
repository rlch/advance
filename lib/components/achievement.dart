class Achievement {
  int id;
  String title;
  List<String> descriptions;
  List<int> goals;
  String iconPath;

  Achievement(
      {this.id, this.title, this.descriptions, this.goals, this.iconPath});

  factory Achievement.fromConfig(Map data) {
    return Achievement(
      id: data['id'],
      title: data['title'],
      descriptions: (data['descriptions'] as List<dynamic>).cast<String>(),
      goals: (data['goals'] as List<dynamic>).cast<int>(),
      iconPath: data['icon_path']
    );
  }
}