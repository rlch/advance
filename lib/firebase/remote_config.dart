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
    try {
      await remoteConfig.fetch(expiration: Duration(seconds: 0));
      await remoteConfig.activateFetched();
    } catch (exception) {
      print(exception);
    }
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
            Workout.fromConfig(k, (v as Map<dynamic, dynamic>), workoutSteps));
  }

  void _createWorkoutAreas() {
    (json.decode(remoteConfig.getString('workout_areas'))
            as Map<String, dynamic>)
        .forEach(
            (k, v) => workoutAreas[k] = WorkoutArea.fromConfig(k, v, workouts));
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
  'achievements': _achievementsDefault,
  'shop_items': _shopItemsDefault
};

final Map<String, dynamic> _workoutStepsDefault = {
  "sit_ups": {"title": "Sit Ups"},
  "push_ups": {"title": "Push Ups"},
  "something": {"title": "Sitweafwe Ups"},
  "fefw": {"title": "Push fUps"},
  "efewf": {"title": "ewf Ups"},
  "wefwef": {"title": "fefe Ups"}
};

final Map<String, dynamic> _workoutsDefault = {
  "arms_general": {
    "title": "Arms Generale",
    "difficulty": "medium",
    "required_level": 1,
    "workout_steps": [
      {"slug": "sit_ups", "type": "timed_set", "duration": 30},
      {"type": "rest", "duration": 20},
      {"slug": "push_ups", "type": "rep_set", "reps": 20}
    ]
  },
  "arms_intense": {
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
    "title": "Arms",
    "description": "fufahuwfhauwhf",
    "workouts": ["arms_general", "arms_intense"],
    "image_path": "workout_areas/arm.png"
  },
  "back": {
    "title": "Back",
    "description": "faewfew",
    "workouts": ["arms_general"],
    "image_path": "workout_areas/back.png"
  }
};

final List<String> _permittedWorkoutsDefault = ["arms", "back"];

final List<dynamic> _achievementsDefault = [
  {
    "slug": "streak",
    "title": "Streak",
    "descriptions": ["desc0", "desc1", "desc2", "finished"],
    "goals": [1, 2, 3],
    "icon_path": "shop/bonfire.png"
  },
  {
    "slug": "stre3ak",
    "title": "Strea3k",
    "descriptions": ["desc0", "desc1", "desc2", "finished"],
    "goals": [5, 2, 3],
    "icon_path": "shop/bonfire.png"
  },
  {
    "slug": "Streak2",
    "title": "Streak",
    "descriptions": ["desc0", "desc1", "desc2", "finished"],
    "goals": [1, 2, 3],
    "icon_path": "shop/bonfire.png"
  }
];

final List<dynamic> _shopItemsDefault = [
  {
    "shop_category": "workouts",
    "name": "Weights",
    "description": "aiewfoaw ijofiw jfoweifjoew",
    "price": 100,
    "icon_path": "workout_areas/weights.png"
  },
  {
    "shop_category": "workouts",
    "name": "Weight loss",
    "description": "aiewfoaw ijofiw jfoweifjoew",
    "price": 500,
    "icon_path": "workout_areas/weight_loss.png"
  },
  {
    "shop_category": "power_ups",
    "name": "Bonfire",
    "description": "aiewfoaw ijofiw jfoweifjoew",
    "price": 300,
    "icon_path": "shop/bonfire.png"
  },
  {
    "shop_category": "power_ups",
    "name": "Bonfire",
    "description": "aiewfoaw ijofiw jfoweifjoew",
    "price": 300,
    "icon_path": "shop/bonfire.png"
  },
  {
    "shop_category": "power_ups",
    "name": "Bonfire",
    "description": "aiewfoaw ijofiw jfoweifjoew",
    "price": 300,
    "icon_path": "shop/bonfire.png"
  }
];
