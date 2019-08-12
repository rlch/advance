import 'package:advance/components/scroll_behaviour.dart';
import 'package:advance/components/user.dart';
import 'package:advance/components/workout_area.dart';
import 'package:advance/screens/workout_detail.dart';
import 'package:advance/styleguide.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class Train extends StatefulWidget {
  Train({Key key}) : super(key: key);

  @override
  _TrainState createState() => _TrainState();
}

class _TrainState extends State<Train> {
  PageController pageController;

  @override
  initState() {
    pageController = PageController(keepPage: true, viewportFraction: 0.8);
    super.initState();
  }

  Widget _buildSlider(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 0.6 * screenHeight,
          child: ScrollConfiguration(
            behavior: BlankScrollBehaviour(),
            child: PageView.builder(
              controller: pageController,
              itemCount: workoutAreas.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildCard(context, workoutAreas[index]);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCard(BuildContext context, WorkoutArea workoutArea) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    User user = Provider.of<User>(context);

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, _, __) =>
                    WorkoutDetailScreen(workoutArea: workoutArea)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Stack(children: <Widget>[
                Hero(
                  tag: "background-${workoutArea.title}",
                  child: Container(
                    height: 0.65 * screenHeight,
                    width: 0.85 * screenWidth,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: workoutArea.gradientColors,
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Align(
                  alignment: Alignment.center,
                  child: Hero(
                    tag: "image-${workoutArea.title}",
                    child: Container(
                      width: screenWidth * 0.5,
                      child: Image.asset(workoutArea.imagePath),
                    ),
                  )),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, bottom: 30.0),
                  child: Container(
                    width: screenWidth * 0.25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Hero(
                          tag: "title-${workoutArea.title}",
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              child: AutoSizeText(
                                workoutArea.title,
                                maxLines: 1,
                                style: AppTheme.heading,
                              ),
                            ),
                          ),
                        ),
                        AutoSizeText("${workoutArea.workouts.length} exercises",
                            maxLines: 1, style: AppTheme.subHeading),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, right: 20.0),
                  child: Hero(
                      tag: "fab-${workoutArea.title}",
                      child: CircularPercentIndicator(
                        radius: 70,
                        lineWidth: 12,
                        animation: true,
                        percent:
                            user.workouts[workoutArea.id].experience.progress,
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.white,
                        center: Text(
                          user.workouts[workoutArea.id].experience.level
                              .toString(),
                          style: TextStyle(
                              fontFamily: 'WorkSans',
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              color: Colors.white),
                        ),
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(child: _buildSlider(context)),
    );
  }
}
