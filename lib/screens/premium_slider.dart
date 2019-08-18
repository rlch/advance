import 'package:advance/components/ui_elements_icons.dart';
import 'package:advance/components/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PremiumSliderScreen extends StatefulWidget {
  PremiumSliderScreen({Key key}) : super(key: key);

  _PremiumSliderScreenState createState() => _PremiumSliderScreenState();
}

class _PremiumSliderScreenState extends State<PremiumSliderScreen> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    AppBar appBar = AppBar(
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
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              "Advance ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Text(' + ',
                  style: TextStyle(
                      color: user.appTheme.themeColor.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w900)),
            )
          ],
        ));

    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: user.appTheme.gradientColors,
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft)),
          ),
          appBar,
          Padding(
            padding: EdgeInsets.only(top: appBar.preferredSize.height - 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 40, bottom: 0),
                      child: ListView(
                        physics: ScrollPhysics(),
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              Icons.add_circle,
                              color: Colors.white,
                              size: 30,
                            ),
                            title: Text("Create custom workouts",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                            title: Text("Compete with your friends",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                          ListTile(
                            leading: Icon(
                              UiElements.energy,
                              color: Colors.white,
                              size: 30,
                            ),
                            title: Text(
                                "Earn energy for completing achievements",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 30,
                            ),
                            title: Text("Unlock more workouts!",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                        ]
                            .map((e) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: e,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {},
                        elevation: 10,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.18, vertical: 12),
                          child: Text('BUY NOW',
                              style: TextStyle(
                                  color: user.appTheme.themeColor.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Invite Friends',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
