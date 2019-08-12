import 'package:advance/components/achievement.dart' as prefix0;
import 'package:advance/components/experience.dart';
import 'package:advance/components/workout.dart';
import 'package:advance/components/workout_area.dart';
import 'package:advance/styleguide.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  final FirebaseUser firebaseUser;
  int energy;
  Map<int, UserAchievement> achievements;
  Map<int, UserWorkout> workouts;
  UserStreak streak;
  ThemeColor themeColor;

  User(this.firebaseUser, this.energy, this.achievements, this.workouts,
      this.streak, this.themeColor);

  factory User.base() {
    return User(
        null,
        0,
        Map.fromIterable(prefix0.achievements,
            key: (achievement) => (achievement as prefix0.Achievement).id,
            value: (_) => UserAchievement(0, 0)),
        Map.fromIterable(workoutAreas,
            key: (area) => (area as WorkoutArea).id,
            value: (area) => UserWorkout(
                Experience(0),
                Map.fromIterable((area as WorkoutArea).workouts,
                    key: (workout) => (workout as Workout).id,
                    value: (_) => UserExercise(0)))),
        UserStreak(0, 0),
        themeColors[0]);
  }

  factory User.fromMap(FirebaseUser firebaseUser, Map data) {
    appTheme = AppTheme(themeColor: themeColors[data['color']]);

    Map<int, UserAchievement> _achievements = {};
    Map<int, UserWorkout> _workouts = {};
    List<UserStreakHistory> _history = [];

    for (final achievement
        in (data['achievements'] as Map<dynamic, dynamic>).entries) {
      _achievements[int.parse(achievement.key)] = UserAchievement(
          achievement.value['level'], achievement.value['progress']);
    }
    for (final workout in (data['workouts'] as Map<dynamic, dynamic>).entries) {
      Map<int, UserExercise> _exercises = {};
      for (final exercise
          in (workout.value['exercises'] as Map<dynamic, dynamic>).entries) {
        _exercises[int.parse(exercise.key)] =
            UserExercise(exercise.value['times_completed']);
      }
      _workouts[int.parse(workout.key)] =
          UserWorkout(Experience(workout.value['experience']), _exercises);
    }
    for (final history
        in (data['streak']['history'] as Map<dynamic, dynamic>).entries) {
      _history.add(UserStreakHistory(
          DateTime.fromMillisecondsSinceEpoch(history.value['timestamp']),
          history.value['timestamp']));
    }
    return User(
        firebaseUser,
        data['energy'],
        _achievements,
        _workouts,
        UserStreak(data['streak']['current'], data['streak']['record'],
            history: _history),
        themeColors[data['color']]);
  }
}

class UserAchievement {
  int level;
  int progress;

  UserAchievement(this.level, this.progress);
}

class UserWorkout {
  Experience experience;
  Map<int, UserExercise> exercises;

  UserWorkout(this.experience, this.exercises);
}

class UserExercise {
  int timesCompleted;

  UserExercise(this.timesCompleted);
}

class UserStreak {
  int current;
  int record;
  List<UserStreakHistory> history;

  UserStreak(this.current, this.record, {this.history});
}

class UserStreakHistory {
  DateTime date;
  int experience;

  UserStreakHistory(this.date, this.experience);
}
