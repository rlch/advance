import 'dart:convert';

import 'package:advance/components/achievement.dart';
import 'package:advance/components/exercise.dart';
import 'package:advance/components/shop_items.dart';
import 'package:advance/components/workout.dart';
import 'package:advance/components/workout_area.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigSetup {
  RemoteConfig remoteConfig;
  Map<String, WorkoutStep> workoutSteps = {};
  Map<String, Workout> workouts = {};
  Map<String, WorkoutArea> workoutAreas = {};
  List<String> permittedWorkouts = [];
  List<Achievement> achievements = [];
  List<ShopItem> shopItems = [];

  Future<RemoteConfigSetup> setup() async {
    remoteConfig = await RemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings());
    await remoteConfig.setDefaults(_remoteConfigDefaults);
    await remoteConfig.fetch(expiration: Duration(seconds: 0));
    await remoteConfig.activateFetched();

    _createPermittedWorkouts();
    _createWorkoutSteps();
    _createWorkouts();
    _createWorkoutAreas();
    _createAchievements();
    _createShopItems();

    return this;
  }

  void _createPermittedWorkouts() {
    permittedWorkouts =
        (json.decode(remoteConfig.getString('permitted_workouts'))
                as List<dynamic>)
            .cast<String>();
  }

  void _createWorkoutSteps() {
    (json.decode(remoteConfig.getString('workout_steps'))
            as Map<String, dynamic>)
        .forEach((k, v) => this.workoutSteps[k] = WorkoutStep.fromConfig(v));
  }

  void _createWorkouts() {
    (json.decode(remoteConfig.getString('workouts')) as Map<String, dynamic>)
        .forEach((k, v) => workouts[k] =
            Workout.fromConfig((v as Map<dynamic, dynamic>), workoutSteps));
  }

  void _createWorkoutAreas() {
    (json.decode(remoteConfig.getString('workout_areas'))
            as Map<String, dynamic>)
        .forEach(
            (k, v) => workoutAreas[k] = WorkoutArea.fromConfig(v, workouts));
  }

  void _createAchievements() {
    (json.decode(remoteConfig.getString('achievements')) as List<dynamic>)
        .forEach((achievement) => achievements
            .add(Achievement.fromConfig(achievement as Map<dynamic, dynamic>)));
  }

  void _createShopItems() {
    (json.decode(remoteConfig.getString('shop_items')) as List<dynamic>)
        .forEach((shopItem) => shopItems
            .add(ShopItem.fromConfig(shopItem as Map<dynamic, dynamic>)));
  }
}

final Map<String, dynamic> _remoteConfigDefaults = {
  'workout_areas': _workoutAreasDefault,
  'workouts': _workoutsDefault,
  'workout_steps': _workoutStepsDefault,
  'permitted_workouts': _permittedWorkoutsDefault,
  'achievements': _achievementsDefault
};

final Map<String, dynamic> _workoutStepsDefault = {
  "sit_ups": {"title": "Sit Ups"},
  "push_ups": {"title": "Push Ups"}
};

final Map<String, dynamic> _workoutsDefault = {
  "arms_general": {
    "id": 1,
    "title": "Arms General",
    "difficulty": "medium",
    "required_level": 1,
    "workout_steps": [
      {"slug": "sit_ups", "type": "timed_set", "duration": 30},
      {"type": "rest", "duration": 20},
      {"slug": "push_ups", "type": "rep_set", "reps": 20}
    ]
  },
  "arms_intense": {
    "id": 2,
    "title": "Arms intense",
    "difficulty": "hard",
    "required_level": 3,
    "workout_steps": [
      {"slug": "sit_ups", "type": "rep_set", "reps": 40},
      {"type": "rest", "duration": 50}
    ]
  }
};

final Map<String, dynamic> _workoutAreasDefault = {
  "arms": {
    "id": 1,
    "title": "Arms",
    "description": "fufahuwfhauwhf",
    "workouts": ["arms_general", "arms_intense"],
    "image_path": "assets/workout_cards/arm.png"
  },
  "back": {
    "id": 2,
    "title": "Back",
    "description": "faewfew",
    "workouts": ["arms_general"],
    "image_path": "assets/workout_cards/back.png"
  }
};

final List<String> _permittedWorkoutsDefault = ["arms", "back"];

final List<dynamic> _achievementsDefault = [
  {
    "id": 1,
    "title": "Streak",
    "descriptions": ["desc0", "desc1", "desc2", "finished"],
    "goals": [1, 2, 3],
    "icon_path": "assets/shop/bonfire.png"
  },
  {
    "id": 2,
    "title": "Strea3k",
    "descriptions": ["desc0", "desc1", "desc2", "finished"],
    "goals": [5, 2, 3],
    "icon_path": "assets/shop/bonfire.png"
  }
];
