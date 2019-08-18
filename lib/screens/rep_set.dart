import 'package:advance/components/exercise.dart';
import 'package:advance/components/user.dart';
import 'package:advance/screens/workout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:provider/provider.dart';

import '../styleguide.dart';

class RepSetScreen extends StatefulWidget {
  RepSetScreen({Key key}) : super(key: key);

  @override
  _RepSetScreenState createState() => _RepSetScreenState();
}

class _RepSetScreenState extends State<RepSetScreen>
    with SingleTickerProviderStateMixin {
  int _currentScreenIndex;

  AnimationController _controller;
  Animation<double> _opacity;

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.0, 0.6, curve: Curves.ease)));
    _controller.forward().orCancel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    WorkoutController workoutController =
        Provider.of<WorkoutController>(context);

    if (_currentScreenIndex == null) {
      _currentScreenIndex = workoutController.currentWorkoutStepIndex;
    }
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
              flightShuttleBuilder: (BuildContext flightContext,
                      Animation<double> animation,
                      HeroFlightDirection flightDirection,
                      BuildContext fromHeroContext,
                      BuildContext toHeroContext) =>
                  Material(
                      color: Colors.transparent, child: toHeroContext.widget),
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
                AppBar(
                  elevation: 0.0,
                  centerTitle: true,
                  title: Hero(
                    tag: 'workout-title',
                    child: Text(
                      workoutController
                          .getWorkoutStepAtIndex(_currentScreenIndex)
                          .title,
                      style: AppTheme.heading,
                    ),
                  ),
                  actions: <Widget>[
                    workoutController.workout.workoutSteps[_currentScreenIndex]
                                .videoId !=
                            null
                        ? Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: IconButton(
                              onPressed: () {
                                return FlutterYoutube.playYoutubeVideoById(
                                    apiKey:
                                        'AIzaSyB5iSZcVN5BGHnHSnRuHSOZ5wVkfFqrghA',
                                    videoId: workoutController
                                        .workout
                                        .workoutSteps[workoutController
                                            .currentWorkoutStepIndex]
                                        .videoId,
                                    autoPlay: true,
                                    fullScreen: false);
                              },
                              color: Colors.white,
                              icon: Icon(Icons.videocam),
                              iconSize: 40,
                            ),
                          )
                        : Container()
                  ],
                  leading: Hero(
                    flightShuttleBuilder: (BuildContext flightContext,
                            Animation<double> animation,
                            HeroFlightDirection flightDirection,
                            BuildContext fromHeroContext,
                            BuildContext toHeroContext) =>
                        Material(
                            color: Colors.transparent,
                            child: toHeroContext.widget),
                    tag: 'close',
                    child: IconButton(
                      iconSize: 40,
                      icon: Icon(Icons.close),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                ),
                FadeTransition(
                  opacity: _opacity,
                  child: Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        (workoutController.getWorkoutStepAtIndex(
                                _currentScreenIndex) as RepSet)
                            .reps
                            .toString(),
                        style: TextStyle(
                            fontFamily: "WorkSans",
                            fontSize: 70,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ),
                      Text(
                        "REPS",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  )),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Hero(
                            tag: 'backward',
                            child: GestureDetector(
                              onTap: () async {
                                final previousStep = await workoutController
                                    .beginPreviousWorkoutStep();
                                return Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                  return previousStep;
                                }));
                              },
                              child: Icon(
                                Icons.keyboard_arrow_left,
                                size: 45,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Hero(
                            tag: 'workout-button',
                            child: RaisedButton(
                              elevation: 8,
                              color: Colors.white,
                              textColor: user.appTheme.themeColor.primary,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 22),
                              onPressed: () async {
                                final nextStep = await workoutController
                                    .beginNextWorkoutStep();
                                await _controller.reverse();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            nextStep));
                              },
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                    fontSize: 20, fontFamily: "WorkSans"),
                              ),
                              shape: new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                            ),
                          ),
                          Container(
                            width: 45,
                          )
                        ],
                      ),
                    ),
                    Hero(
                      tag: 'timeline',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                            workoutController.workout.workoutSteps.length,
                            (index) {
                          return Flexible(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(5)),
                                  color: index <=
                                          workoutController
                                              .currentWorkoutStepIndex
                                      ? Colors.white
                                      : Colors.black.withOpacity(0.3),
                                ),
                                height: 10,
                              ),
                            ),
                          );
                        }),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
