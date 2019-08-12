import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData mainTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primarySwatch: Colors.blue
  );

  static final TextStyle welcomeTitle = TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 60,
      fontFamily: "WorkSans",
      color: Colors.white,
      decoration: TextDecoration.none);

  static final TextStyle welcomeDescription = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 22,
      fontFamily: "WorkSans",
      color: Colors.white,
      decoration: TextDecoration.none);

  static final TextStyle heading = TextStyle(
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.w900,
    fontSize: 34,
    color: Colors.white.withOpacity(0.9),
    letterSpacing: 1.2,
  );

  static final TextStyle subHeading = TextStyle(
      inherit: true,
      fontFamily: 'WorkSans',
      fontWeight: FontWeight.w500,
      fontSize: 24,
      color: Colors.white.withOpacity(0.9));
}
