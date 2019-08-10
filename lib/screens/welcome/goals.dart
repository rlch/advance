import 'package:advance/screens/welcome/signup_form.dart';
import 'package:advance/styleguide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';

class GoalsScreen extends StatefulWidget {
  GoalsScreen({Key key}) : super(key: key);

  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Stack(children: <Widget>[
          SizedBox.expand(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                    Colors.pink.shade200,
                    Colors.redAccent.shade400
                  ])),
            ),
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
                Flexible(
                  child: Villain(
                    villainAnimation: VillainAnimation.fade(),
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(20),
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.white, width: 2)),
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                _selected = 1;
                              });
                            },
                            leading: Icon(Icons.aspect_ratio),
                            title: Text(
                              "Casual",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: (_selected == 1)
                                      ? Colors.pink
                                      : Colors.black),
                            ),
                            trailing: Text("1 workout a day"),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  left:
                                      BorderSide(color: Colors.white, width: 2),
                                  right:
                                      BorderSide(color: Colors.white, width: 2),
                                  top: BorderSide(
                                      color: Colors.black.withOpacity(0.15),
                                      width: 2),
                                  bottom: BorderSide(
                                      color: Colors.black.withOpacity(0.15),
                                      width: 2))),
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                _selected = 2;
                              });
                            },
                            leading: Icon(Icons.aspect_ratio),
                            title: Text(
                              "Hero",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: (_selected == 2)
                                      ? Colors.pink
                                      : Colors.black),
                            ),
                            trailing: Text("2 workouts a day"),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(20)),
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.white, width: 2)),
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                _selected = 3;
                              });
                            },
                            leading: Icon(Icons.aspect_ratio),
                            title: Text(
                              "Legend",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: (_selected == 3)
                                      ? Colors.pink
                                      : Colors.black),
                            ),
                            trailing: Text('3 workouts a day'),
                          ),
                        )
                      ],
                    ),
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
                          builder: (BuildContext context) =>
                              SignUpFormScreen()));
                    },
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
