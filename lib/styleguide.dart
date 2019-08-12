import 'package:flutter/material.dart';

final List<ThemeColor> themeColors = [
  ThemeColor(Colors.pink, Color(0xffec407a), Colors.pink.shade200,
      Colors.redAccent.shade400),
  ThemeColor(
      Colors.purple, Color(0xffB06AB3), Color(0xff4568DC), Color(0xffB06AB3)),
  ThemeColor(
      Colors.red, Color(0xffcb2d3e), Color(0xffef473a), Color(0xffcb2d3e)),
  ThemeColor(Colors.deepPurple, Colors.deepPurple[400], Color(0xffb085f5),
      Color(0xff4d2c91)),
  ThemeColor(Colors.lightBlue, Color(0xff65C7F7), Color(0xff9CECFB),
      Color(0xff0052D4)),
  ThemeColor(Colors.green, Colors.green, Color(0xff80e27e), Color(0xff087f23)),
  ThemeColor(
      Colors.orange, Color(0xffff7e5f), Color(0xfffeb47b), Color(0xffff7e5f),
      darkText: true),
  ThemeColor(
      Colors.pink, Color(0xffff5f6d), Color(0xffffc371), Color(0xffff5f6d))
];

class ThemeColor {
  final MaterialColor swatch;
  final Color primary, light, dark;
  final bool darkText;
  ThemeColor(this.swatch, this.primary, this.light, this.dark,
      {this.darkText = false});
}

class AppTheme {
  final ThemeColor themeColor;
  AppTheme(this.themeColor);

  List<Color> get gradientColors {
    return [themeColor.light, themeColor.dark];
  }

  final Color iconGrey = Colors.black.withOpacity(0.3);

  final Color circleDark = Colors.black.withAlpha(50);

  ThemeData get mainTheme {
    return ThemeData(
        primaryColor: themeColor.primary,
        accentColor: themeColor.dark,
        fontFamily: "WorkSans",
        textTheme: TextTheme(
            headline: TextStyle(color: Colors.white,
                fontSize: 34, letterSpacing: 1.2, fontWeight: FontWeight.w900),
            subhead: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 24,
            )),
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: themeColor.swatch);
  }

  static final ThemeData rootTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Color(0xffec407a),
      accentColor: Colors.redAccent.shade400,
      fontFamily: "WorkSans",
      textTheme: TextTheme(
          headline: TextStyle(
              fontSize: 34, letterSpacing: 1.2, fontWeight: FontWeight.w900),
          subhead: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
          )),
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: Colors.pink[400]);

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
    color: Colors.white,
    letterSpacing: 1.2,
  );

  static final TextStyle subHeading = TextStyle(
      inherit: true,
      fontFamily: 'WorkSans',
      fontWeight: FontWeight.w500,
      fontSize: 24,
      color: Colors.white);
}
