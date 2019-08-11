import 'package:flutter/material.dart';

class Achievement {
  int id;
  String title;
  List<String> descriptions;
  List<int> goals;
  String iconPath;
  List<Color> gradientColors;
  int currentLevel;
  int currentGoalProgress;

  Achievement({this.id, this.title, this.descriptions, this.goals, this.iconPath, this.gradientColors, this.currentLevel = 0, this.currentGoalProgress = 0});

  String description () {
    return descriptions[currentLevel];
  }
  int goal () {
    return goals[currentLevel];
  }
}

List<Achievement> achievements = [
  Achievement(
    id: 1,
    title: "Streak",
    descriptions: ["desc0", "desc1", "desc2", 'finsihed'],
    goals: [1, 2, 3],
    iconPath: 'assets/shop/bonfire.png',
    gradientColors: [Colors.pink.shade200, Colors.redAccent.shade400],
    currentLevel: 0,
    currentGoalProgress: 0,
  ),
  Achievement(
    id: 2,
    title: "Streak",
    descriptions: ["desc0", "desc1", "desc2", 'finsihed'],
    goals: [1, 2, 5],
    iconPath: 'assets/shop/bonfire.png',
    gradientColors: [Colors.pink.shade200, Colors.redAccent.shade400],
    currentLevel: 2,
    currentGoalProgress: 3,
  ),
];