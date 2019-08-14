class Achievement {
  String slug;
  String title;
  List<String> descriptions;
  List<int> goals;
  String iconPath;

  Achievement(
      {this.slug, this.title, this.descriptions, this.goals, this.iconPath});

  factory Achievement.fromConfig(Map data) {
    return Achievement(
      slug: data.keys.first,
      title: data['title'],
      descriptions: (data['descriptions'] as List<dynamic>).cast<String>(),
      goals: (data['goals'] as List<dynamic>).cast<int>(),
      iconPath: data['icon_path']
    );
  }
}