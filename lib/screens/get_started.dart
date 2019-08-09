import 'package:advance/styleguide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';

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
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.pink.shade200, Colors.redAccent.shade400])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Column(
                    children: <Widget>[
                      Hero(
                        tag: 'welcome_title',
                        child: Text(
                          "About you",
                          style: AppTheme.welcomeTitle,
                        ),
                      ),
                      Hero(
                        tag: 'welcome_description',
                        child: Text(
                          "Fitness can be fun.",
                          style: AppTheme.welcomeDescription,
                        ),
                      )
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Hero(
                  tag: 'get_started_box',
                  child: SizedBox(
                    height: screenHeight * 0.65,
                    width: screenWidth * 0.85,
                    child: Container(
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 40,
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
                                      size: 40,
                                    ),
                                  ),
                                  fillColor: Colors.pink,
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Weight (kg)',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "WorkSans"),
                                ),
                                SizedBox(height: 10,),
                                FluidSlider(
                                  min: 30,
                                  max: 150,
                                  start: Container(),
                                  end: Container(),
                                  sliderColor: Colors.pink.shade400,
                                  value: _weight,
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
                            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Height (cm)',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "WorkSans"),
                                ),
                                SizedBox(height: 10,),
                                FluidSlider(
                                  min: 130,
                                  max: 200,
                                  start: Container(),
                                  end: Container(),
                                  sliderColor: Colors.pink.shade400,
                                  value: _height,
                                  onChanged: (double newValue) {
                                    setState(() {
                                      _height = newValue;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(Icons.arrow_forward, color: Colors.pink, size: 40,),
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
