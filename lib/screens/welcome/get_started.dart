import 'package:advance/screens/welcome/goals.dart';
import 'package:advance/styleguide.dart';
import 'package:flutter/material.dart';

class GetStartedScreen extends StatefulWidget {
  GetStartedScreen({Key key}) : super(key: key);

  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  double _weight = 60;
  double _height = 160;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.pink.shade200, Colors.redAccent.shade400])),
          ),
        ),
        Column(
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
            Container(
              width: screenWidth * 0.85,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(40)),
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          fillColor: Colors.blue,
                          onPressed: () {},
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
                          fillColor: Colors.pink,
                          onPressed: () {},
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GoalsScreen()));
                },
              ),
            )
          ],
        ),
      ],
    ));
  }
}
