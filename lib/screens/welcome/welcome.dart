import 'package:advance/screens/welcome/get_started.dart';
import 'package:advance/screens/welcome/login_form.dart';
import 'package:advance/styleguide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
          Hero(
            tag: "welcome-bg",
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                  Colors.pink.shade200,
                  Colors.redAccent.shade400
                ]))),
          ),
          SafeArea(
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
                            "Advance",
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
                Villain(
                  villainAnimation: VillainAnimation.fade(),
                  child: ButtonTheme(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                            style: BorderStyle.solid,
                            color: Colors.white,
                            width: 4)),
                    minWidth: 200,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Hero(
                            tag: 'get_started_box',
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => GetStartedScreen()));
                              },
                              child: Text(
                                "Get Started",
                                style: TextStyle(fontSize: 20),
                              ),
                              color: Colors.white,
                              textColor: Colors.pink,
                              padding: EdgeInsets.all(10),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          RaisedButton(
                            color: Colors.white.withOpacity(0),
                            elevation: 0,
                            focusColor: Colors.white,
                            highlightElevation: 0,
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginFormScreen()));
                            },
                            child:
                                Text("Login", style: TextStyle(fontSize: 20)),
                            padding: EdgeInsets.all(10),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
