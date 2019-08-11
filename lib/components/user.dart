class User {
  final int id;
  String email;
  int energy;
  Map<int, Map<String, int>> achievements;
  Map<int, Map<String, dynamic>> workouts;
  Map<String, dynamic> streak;

  User({this.id, this.email, this.energy, this.achievements, this.workouts, this.streak});
}
