import 'package:advance/components/ui_elements_icons.dart';
import 'package:advance/components/user.dart';
import 'package:advance/screens/workout.dart';
import 'package:advance/screens/workout_custom_create.dart';
import 'package:advance/styleguide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villain.dart';
import 'package:provider/provider.dart';

class WorkoutCustomScreen extends StatefulWidget {
  WorkoutCustomScreen({Key key}) : super(key: key);

  @override
  _WorkoutCustomScreenState createState() => _WorkoutCustomScreenState();
}

class _WorkoutCustomScreenState extends State<WorkoutCustomScreen> {
  PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(keepPage: true, viewportFraction: 0.8);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    var appBar = AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          iconSize: 40,
          icon: Icon(Icons.close),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Material(
            color: Colors.transparent,
            child: Container(child: Text("Create", style: AppTheme.heading))));

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: 'workout-create',
          child: Icon(
            Icons.add,
            color: user.appTheme.themeColor.primary,
          ),
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => WorkoutCustomCreateScreen()));
          },
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
              tag: 'workout-custom',
              child: DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: user.appTheme.gradientColors,
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft)),
              ),
            ),
            appBar,
            SafeArea(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          32, appBar.preferredSize.height, 8, 0),
                      child: Villain(
                        villainAnimation: VillainAnimation.fromBottom(
                            relativeOffset: 0.2,
                            from: Duration(milliseconds: 100),
                            to: Duration(milliseconds: 500)),
                        secondaryVillainAnimation: VillainAnimation.fade(),
                        animateExit: true,
                        child: Center(
                          child: Text("Create your own workout",
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
                          itemCount: (user.customWorkouts?.length ?? 0),
                          itemBuilder: (BuildContext context, int index) {
                            return _buildWorkout(context, index);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.1,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkout(BuildContext context, int index) {
    User user = Provider.of<User>(context);
    String slug = user.customWorkouts.keys.elementAt(index);
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
                  user.customWorkouts[slug].title,
                  style: TextStyle(
                      fontFamily: "WorkSans",
                      fontSize: 23,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("LEVEL",
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
                    children: <Widget>[
                      Icon(Icons.timer),
                      Text(user.customWorkouts[slug].duration.inMinutes
                              .toString() +
                          ' mins')
                    ],
                  ),
                  Column(
                    children: <Widget>[Icon(UiElements.progress), Text("gaer")],
                  )
                ],
              ),
            ),
            RaisedButton(
              color: user.appTheme.themeColor.primary,
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 22),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        WorkoutCountdownScreen(user.customWorkouts[slug])));
              },
              child: Text(
                'Train',
                style: TextStyle(fontSize: 20, fontFamily: "WorkSans"),
              ),
              shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
            )
          ],
        ),
      ),
    );
  }
}
