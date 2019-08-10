import 'package:advance/styleguide.dart';
import 'package:flutter/material.dart';

class SignUpFormScreen extends StatefulWidget {
  SignUpFormScreen({Key key}) : super(key: key);

  @override
  _SignUpFormScreenState createState() => _SignUpFormScreenState();
}

class _SignUpFormScreenState extends State<SignUpFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
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
          Column(
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
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      style: TextStyle(
                          color: Colors.white, decorationColor: Colors.white),
                      decoration: InputDecoration(
                          focusColor: Colors.white,
                          labelText: "Username",
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 4)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 4)),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 20))),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextFormField(
                      obscureText: true,
                      cursorColor: Colors.white,
                      style: TextStyle(
                          color: Colors.white, decorationColor: Colors.white),
                      decoration: InputDecoration(
                          focusColor: Colors.white,
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 4)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 4)),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 20))),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
