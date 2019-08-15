import 'package:advance/components/scroll_behaviour.dart';
import 'package:advance/components/user.dart';
import 'package:advance/components/workout_area.dart';
import 'package:advance/screens/workout_detail.dart';
import 'package:advance/styleguide.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cache_image/cache_image.dart';
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
    List<String> permittedWorkouts = Provider.of<List<String>>(context);
    Map<String, WorkoutArea> workoutAreas =
        Provider.of<Map<String, WorkoutArea>>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 0.6 * screenHeight,
          child: ScrollConfiguration(
            behavior: BlankScrollBehaviour(),
            child: PageView.builder(
              controller: pageController,
              itemCount: permittedWorkouts.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildCard(
                    context, workoutAreas[permittedWorkouts[index]]);
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
                            colors: user.appTheme.gradientColors,
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
                child: Container(
                    width: screenWidth * 0.5,
                    child: CacheImage.firebase(
                      prefix: 'gs://advance-72a11.appspot.com/',
                      path: workoutArea.imagePath,
                    )),
              ),
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
                        Material(
                          color: Colors.transparent,
                          child: Container(
                            child: AutoSizeText(
                              workoutArea.title,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.headline,
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
                            user.workouts[workoutArea.slug].experience.progress,
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.white,
                        backgroundColor: user.appTheme.circleDark,
                        center: Text(
                          user.workouts[workoutArea.slug].experience.level
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
