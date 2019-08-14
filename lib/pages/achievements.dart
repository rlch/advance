import 'package:advance/components/achievement.dart';
import 'package:advance/components/scroll_behaviour.dart';
import 'package:advance/components/user.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class Achievements extends StatefulWidget {
  Achievements({Key key}) : super(key: key);

  @override
  _AchievementsState createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  List<Widget> _buildStars(int currentLevel) {
    List<Widget> stars = [];
    for (var i = 0; i < currentLevel; i += 1) {
      stars.add(Icon(Icons.star, color: Colors.white));
    }
    for (var i = 0; i < 3 - currentLevel; i += 1) {
      stars.add(Icon(
        Icons.star,
        color: Colors.black.withAlpha(70),
      ));
    }
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    User user = Provider.of<User>(context);
    List<Achievement> achievements = Provider.of<List<Achievement>>(context);
    return ScrollConfiguration(
      behavior: BlankScrollBehaviour(),
      child: Container(
        child: ListView.builder(
          itemCount: achievements.length,
          itemBuilder: (BuildContext context, int index) {
            final achievement = achievements[index];
            return Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 30, right: 20),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: user.appTheme.gradientColors,
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              achievement.iconPath,
                              width: screenWidth * 0.15,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: _buildStars(
                                  user.achievements[achievement.id].level),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              achievement.title,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  fontFamily: "WorkSans"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              achievement.descriptions[
                                  user.achievements[achievement.id].level],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: "WorkSans"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: LinearPercentIndicator(
                                    lineHeight: 18,
                                    percent: user.achievements[achievement.id]
                                            .progress /
                                        achievement.goals[user
                                            .achievements[achievement.id]
                                            .level],
                                    backgroundColor:
                                        Colors.black.withOpacity(0.1),
                                    progressColor:
                                        user.appTheme.themeColor.light,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  user.achievements[achievement.id].progress
                                          .toString() +
                                      "/" +
                                      achievement.goals[user
                                              .achievements[achievement.id]
                                              .level]
                                          .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black.withOpacity(0.4)),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
