import 'package:advance/components/achievement.dart';
import 'package:advance/components/exercise.dart';
import 'package:advance/components/experience.dart';
import 'package:advance/components/workout.dart';
import 'package:advance/components/workout_area.dart';
import 'package:advance/firebase/remote_config.dart';
import 'package:advance/styleguide.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class User {
  final FirebaseUser firebaseUser;
  int energy, gender, height, weight;
  Map<String, UserAchievement> achievements;
  Map<String, UserWorkout> workouts;
  UserStreak streak;
  AppTheme appTheme;
  List<String> permittedWorkouts;
  Map<String, Workout> customWorkouts;

  User(
      this.firebaseUser,
      this.energy,
      this.achievements,
      this.workouts,
      this.streak,
      this.appTheme,
      this.gender,
      this.height,
      this.weight,
      this.permittedWorkouts,
      {this.customWorkouts});

  factory User.base(RemoteConfigSetup remoteConfigSetup) {
    return User(
        null,
        0,
        Map.fromIterable(remoteConfigSetup.achievements,
            key: (achievement) => (achievement as Achievement).slug,
            value: (_) => UserAchievement(0, 0)),
        Map.fromIterable(remoteConfigSetup.workoutAreas.values,
            key: (area) => (area as WorkoutArea).slug,
            value: (area) => UserWorkout(
                Experience(100.0),
                Map.fromIterable((area as WorkoutArea).workouts,
                    key: (workout) => (workout as Workout).slug,
                    value: (_) => UserExercise(0)))),
        UserStreak(0, 0, 0),
        AppTheme(themeColors[0]),
        0,
        0,
        0,
        remoteConfigSetup.permittedWorkouts,
        customWorkouts: {});
  }

  factory User.fromMap(FirebaseUser firebaseUser, Map data) {
    Map<String, UserAchievement> _achievements = {};
    Map<String, UserWorkout> _workouts = {};
    Map<String, UserStreakHistory> _history = {};

    print(AppTheme(themeColors[data['color']]).themeColor.light);

    for (final achievement
        in (data['achievements'] as Map<dynamic, dynamic>).entries) {
      _achievements[achievement.key] = UserAchievement(
          achievement.value['level'], achievement.value['progress']);
    }
    for (final workout in (data['workouts'] as Map<dynamic, dynamic>).entries) {
      Map<String, UserExercise> _exercises = {};
      for (final exercise
          in (workout.value['exercises'] as Map<dynamic, dynamic>).entries) {
        _exercises[exercise.key] =
            UserExercise(exercise.value['times_completed']);
      }
      _workouts[workout.key] =
          UserWorkout(Experience(workout.value['experience']), _exercises);
    }

    WorkoutStep _mapToStep(Map<dynamic, dynamic> step) {
      switch (step['type']) {
        case "timed_set":
          return TimedSet(step['title'], Duration(seconds: step['duration']));
        case "rep_set":
          return RepSet(step['title'], step['reps']);
        case "rest":
          return Rest(Duration(seconds: step['duration']));
        default:
          return null;
      }
    }

    print(data['custom_workouts']);

    Map<String, Workout> _customWorkouts = {};
    (data['custom_workouts'] as Map<dynamic, dynamic>).entries.forEach(
        (customWorkout) => _customWorkouts[customWorkout.key] = Workout(
            customWorkout.key,
            customWorkout.value['title'],
            (customWorkout.value['workout_steps']
                    as List<dynamic>)
                .map((step) => _mapToStep(step as Map<dynamic, dynamic>))
                .toList()));

    print(_customWorkouts);
    for (final history
        in (data['streak']['history'] as Map<dynamic, dynamic>).entries) {
      _history[DateFormat('dd-MM-yyyy').format(
          DateTime.fromMillisecondsSinceEpoch(
              history.value['timestamp']))] = UserStreakHistory(
          DateTime.fromMillisecondsSinceEpoch(history.value['timestamp']),
          history.value['experience'],
          history.value['workouts_completed']);
    }
    return User(
        firebaseUser,
        data['energy'],
        _achievements,
        _workouts,
        UserStreak(data['streak']['current'], data['streak']['record'],
            data['streak']['target'], history: _history),
        AppTheme(themeColors[data['color']]),
        data['gender'],
        data['height'],
        data['weight'],
        (data['permitted_workouts'] as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        customWorkouts: _customWorkouts);
  }
}

class UserAchievement {
  int level;
  int progress;

  UserAchievement(this.level, this.progress);
}

class UserWorkout {
  Experience experience;
  Map<String, UserExercise> exercises;

  UserWorkout(this.experience, this.exercises);
}

class UserExercise {
  int timesCompleted;

  UserExercise(this.timesCompleted);
}

class UserStreak {
  int current;
  int record;
  int target;
  Map<String, UserStreakHistory> history;

  UserStreak(this.current, this.record, this.target, {this.history});
}

class UserStreakHistory {
  DateTime date;
  double experience;
  int workoutsCompleted;

  UserStreakHistory(this.date, this.experience, this.workoutsCompleted);
}
