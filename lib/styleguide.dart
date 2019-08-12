import 'package:flutter/material.dart';

AppTheme appTheme;

final List<ThemeColor> themeColors = [
  ThemeColor(Colors.deepPurple[400], Color(0xb085f5), Color(0x4d2c91)),
  ThemeColor(Colors.pink[200], Color(0xffc1e3), Color(0xbf5f82),
      darkText: true),
  ThemeColor(Colors.pink[400], Color(0xff77a9), Color(0xb4004e)),
  ThemeColor(Colors.indigo[700], Color(0x666ad1), Color(0x001970)),
  ThemeColor(Colors.lightBlue, Color(0x039be5), Color(0x006db3)),
  ThemeColor(Colors.green, Color(0x80e27e), Color(0x087f23)),
  ThemeColor(Colors.amber[700], Color(0xffd149), Color(0xc67100),
      darkText: true),
  ThemeColor(Colors.blueGrey[800], Color(0x62727b), Color(0x102027))
];

class ThemeColor {
  final Color primary, light, dark;
  final bool darkText;
  ThemeColor(this.primary, this.light, this.dark, {this.darkText = false});
}

class AppTheme {
  final ThemeColor themeColor;
  AppTheme({this.themeColor});

  static final ThemeData mainTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white, primarySwatch: Colors.blue);

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
