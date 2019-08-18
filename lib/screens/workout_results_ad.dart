import 'dart:io';

import 'package:advance/components/user.dart';
import 'package:advance/screens/workout.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../styleguide.dart';

class WorkoutResultsAdScreen extends StatefulWidget {
  WorkoutResultsAdScreen({Key key}) : super(key: key);

  @override
  _WorkoutResultsLevelScreenState createState() =>
      _WorkoutResultsLevelScreenState();
}

class _WorkoutResultsLevelScreenState extends State<WorkoutResultsAdScreen> {

  bool _adLoaded = false;

  InterstitialAd interstitialAd;
  InterstitialAd buildInterstitual() {
    return InterstitialAd(
        adUnitId: "ca-app-pub-3940256099942544/4411468910",
        targetingInfo: MobileAdTargetingInfo(
          keywords: ['Fitness', 'Health'],
        ),
        listener: (MobileAdEvent event) async {
          switch (event) {
            case MobileAdEvent.loaded:
              setState(() {
                _adLoaded = true;
              });
              break;
            case MobileAdEvent.closed:
              Navigator.of(context).popUntil((route) => route.isFirst);
              break;
            default:
              print(event);
              break;
          }
        });
  }

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(
      appId: Platform.isAndroid
          ? 'ca-app-pub-1755922355375919~5873090316'
          : 'ca-app-pub-1755922355375919~7915718156',
    );
    interstitialAd = buildInterstitual()..load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    WorkoutController workoutController =
        Provider.of<WorkoutController>(context);
    interstitialAd.show();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
              tag: workoutController.workoutArea == null
                  ? 'workout-custom'
                  : "background-${workoutController.workoutArea.title}",
              child: DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: user.appTheme.gradientColors,
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft)),
              )),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SafeArea(
                  child: Hero(
                    tag: 'workout-title',
                    flightShuttleBuilder: (BuildContext flightContext,
                            Animation<double> animation,
                            HeroFlightDirection flightDirection,
                            BuildContext fromHeroContext,
                            BuildContext toHeroContext) =>
                        Material(
                            color: Colors.transparent,
                            child: toHeroContext.widget),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        "Help us grow and keep fitness free!",
                        textAlign: TextAlign.center,
                        style: AppTheme.heading,
                      ),
                    ),
                  ),
                ),
                _adLoaded
                    ? Container()
                    : CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                Container()
              ],
            ),
          ),
        ],
      )),
    );
  }
}
