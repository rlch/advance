import 'package:advance/components/user.dart';
import 'package:advance/firebase/auth.dart';
import 'package:advance/firebase/user_service.dart';
import 'package:advance/main.dart';
import 'package:advance/styleguide.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villain.dart';
import 'package:provider/provider.dart';

class SignUpFormScreen extends StatefulWidget {
  SignUpFormScreen({Key key}) : super(key: key);

  @override
  _SignUpFormScreenState createState() => _SignUpFormScreenState();
}

class _SignUpFormScreenState extends State<SignUpFormScreen> {
  final _emailKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  String _emailValidator;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.pink.shade200, Colors.redAccent.shade400])),
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
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Form(
                          key: _emailKey,
                          child: TextFormField(
                            validator: (value) {
                              if (!EmailValidator.validate(value)) {
                                return 'Please enter a valid email.';
                              } else if (_emailValidator != null) {
                                return _emailValidator;
                              }
                              return null;
                            },
                            controller: _emailController,
                            cursorColor: Colors.white,
                            style: TextStyle(
                                color: Colors.white,
                                decorationColor: Colors.white),
                            decoration: InputDecoration(
                                focusColor: Colors.white,
                                labelText: "Email",
                                errorStyle: TextStyle(color: Colors.white),
                                labelStyle: TextStyle(color: Colors.white),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 20))),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Form(
                          key: _passwordKey,
                          child: TextFormField(
                            validator: (value) {
                              if (value.length < 6) {
                                return 'The password must be 6 characters long or more.';
                              }
                              return null;
                            },
                            controller: _passwordController,
                            obscureText: true,
                            cursorColor: Colors.white,
                            style: TextStyle(
                                color: Colors.white,
                                decorationColor: Colors.white),
                            decoration: InputDecoration(
                                focusColor: Colors.white,
                                labelText: "Password",
                                labelStyle: TextStyle(color: Colors.white),
                                errorStyle: TextStyle(color: Colors.white),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 20))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () async {
                      if (_emailKey.currentState.validate() &&
                          _passwordKey.currentState.validate()) {
                        final FirebaseUser signupResponse =
                            await signUpWithEmail(_emailController.text.trim(),
                                _passwordController.text);

                        if (signupResponse != null) {
                          FirebaseAnalytics analytics = FirebaseAnalytics();
                          runApp(
                            MultiProvider(
                                providers: [
                                  StreamProvider<User>(
                                      initialData: User.base(),
                                      builder: (_) => UserService()
                                          .streamUser(signupResponse)),
                                ],
                                child: MaterialApp(
                                    navigatorObservers: [
                                      new VillainTransitionObserver(),
                                      FirebaseAnalyticsObserver(
                                          analytics: analytics)
                                    ],
                                    theme:
                                        AppTheme.mainTheme,
                                    home: MainController())),
                          );
                        } else {
                          setState(() {
                            _emailValidator = 'Email in use.';
                            _emailKey.currentState.validate();
                            _emailValidator = null;
                          });
                        }
                      }
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
