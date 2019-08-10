import 'package:advance/components/ui_elements_icons.dart';
import 'package:advance/components/workout.dart';
import 'package:advance/components/workout_area.dart';
import 'package:advance/screens/workout.dart';
import 'package:advance/styleguide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villain.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final WorkoutArea workoutArea;
  WorkoutDetailScreen({Key key, this.workoutArea}) : super(key: key);

  @override
  _WorkoutDetailScreenState createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(keepPage: true, viewportFraction: 0.8);
    super.initState();
  }

  Widget _buildWorkout(BuildContext context, Workout workout) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 10)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  workout.title,
                  style: TextStyle(
                      fontFamily: "WorkSans",
                      fontSize: 23,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("LEVEL ${workout.requiredLevel}",
                    style: TextStyle(
                        fontFamily: "WorkSans",
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.black.withOpacity(0.6)))
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[Icon(Icons.timer), Text("5 mins")],
                  ),
                  Column(
                    children: <Widget>[
                      Icon(UiElements.progress),
                      Text(workout.getDifficultyString())
                    ],
                  )
                ],
              ),
            ),
            RaisedButton(
              color: widget.workoutArea.getButtonColor(),
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 22),
              onPressed: () {
                if (workout.requiredLevel <
                    widget.workoutArea.experience.level) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkoutCountdownScreen(
                              workout, widget.workoutArea)));
                }
              },
              child: (workout.requiredLevel <
                      widget.workoutArea.experience.level)
                  ? Text(
                      'Train',
                      style: TextStyle(fontSize: 20, fontFamily: "WorkSans"),
                    )
                  : Icon(Icons.lock_outline),
              shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    var appBar = AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          iconSize: 40,
          icon: Icon(Icons.close),
          color: Colors.white.withOpacity(0.9),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Hero(
            tag: "title-${widget.workoutArea.title}",
            child: Material(
                color: Colors.transparent,
                child: Container(
                    child: Text(widget.workoutArea.title,
                        style: AppTheme.heading)))));

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
              tag: "background-${widget.workoutArea.title}",
              child: DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: widget.workoutArea.gradientColors,
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft)),
              )),
          appBar,
          SafeArea(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(32, appBar.preferredSize.height, 8, 0),
                    child: Villain(
                      villainAnimation: VillainAnimation.fromBottom(
                          relativeOffset: 0.2,
                          from: Duration(milliseconds: 100),
                          to: Duration(milliseconds: 500)),
                      secondaryVillainAnimation: VillainAnimation.fade(),
                      animateExit: true,
                      child: Center(
                        child: Text(widget.workoutArea.description,
                            style: TextStyle(
                                fontFamily: "WorkSans",
                                fontSize: 20,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                  Villain(
                    villainAnimation: VillainAnimation.scale(
                        fromScale: 0.5,
                        toScale: 1,
                        from: Duration(milliseconds: 100),
                        to: Duration(milliseconds: 300)),
                    secondaryVillainAnimation: VillainAnimation.fade(),
                    child: SizedBox(
                      height: screenHeight * 0.45,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: widget.workoutArea.workouts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildWorkout(
                              context, widget.workoutArea.workouts[index]);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.1,)
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Hero(
                  tag: 'fab-${widget.workoutArea.title}',
                  child: CircularPercentIndicator(
                    radius: 70,
                    lineWidth: 12,
                    animation: false,
                    percent: widget.workoutArea.experience.progress,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.white,
                    center: Text(
                      widget.workoutArea.experience.level.toString(),
                      style: TextStyle(
                          fontFamily: 'WorkSans',
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          color: Colors.white),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
