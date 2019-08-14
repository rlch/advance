import 'package:advance/screens/welcome/goals.dart';
import 'package:advance/styleguide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:provider/provider.dart';

class SignUpDetails {
  int weight = 60;
  int height = 160;
  int gender = 0;
  // 0: not known
  // 1: male
  // 2: female

  int streakGoal;
  // 0: casual
  // 1: hero
  // 2: legend
}

class GetStartedScreen extends StatefulWidget {
  GetStartedScreen({Key key}) : super(key: key);

  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  SignUpDetails signUpDetails = SignUpDetails();
  int _selected = 0;
  double _height = 160;
  double _weight = 60;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Provider.value(
      value: signUpDetails,
      child: Scaffold(
          body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.pink.shade200, Colors.redAccent.shade400])),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "About you",
                          style: AppTheme.welcomeTitle,
                        ),
                        Text(
                          "Fitness can be fun.",
                          style: AppTheme.welcomeDescription,
                        )
                      ],
                    )),
                Villain(
                  villainAnimation: VillainAnimation.fade(),
                  child: Container(
                    width: screenWidth * 0.85,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40)),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RawMaterialButton(
                                shape: CircleBorder(),
                                splashColor: Colors.grey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                fillColor: (_selected == 2)
                                    ? Colors.grey
                                    : Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    _selected = 1;
                                  });
                                },
                              ),
                              RawMaterialButton(
                                shape: CircleBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                fillColor: (_selected == 1)
                                    ? Colors.grey
                                    : Colors.pink,
                                onPressed: () {
                                  setState(() {
                                    _selected = 2;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 40),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Weight: ${_weight.round()}kg',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "WorkSans"),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Slider(
                                value: _weight,
                                min: 30,
                                max: 150,
                                onChanged: (double newValue) {
                                  setState(() {
                                    _weight = newValue;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10.0, right: 40, left: 40),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Height: ${_height.round()}cm',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "WorkSans"),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Slider(
                                value: _height,
                                min: 130,
                                max: 200,
                                onChanged: (double newValue) {
                                  setState(() {
                                    _height = newValue;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Villain(
                  villainAnimation: VillainAnimation.fade(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Hero(
                      tag: 'welcome-arrow',
                      flightShuttleBuilder: (BuildContext flightContext,
                              Animation<double> animation,
                              HeroFlightDirection flightDirection,
                              BuildContext fromHeroContext,
                              BuildContext toHeroContext) =>
                          Material(
                              color: Colors.transparent,
                              child: toHeroContext.widget),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () {
                          signUpDetails.gender = _selected;
                          signUpDetails.height = _height.round();
                          signUpDetails.weight = _weight.round();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => Provider.value(
                                  value: signUpDetails, child: GoalsScreen())));
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
