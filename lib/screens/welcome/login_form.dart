import 'package:advance/components/user.dart';
import 'package:advance/firebase/auth.dart';
import 'package:advance/firebase/remote_config.dart';
import 'package:advance/firebase/user_service.dart';
import 'package:advance/main.dart';
import 'package:advance/styleguide.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';

class LoginFormScreen extends StatefulWidget {
  LoginFormScreen({Key key}) : super(key: key);

  @override
  _LoginFormScreenState createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final _emailKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  String _emailValidator;
  String _passwordValidator;

  bool _isLoading = false;
  bool _keyboardVisible = false;

  @override
  void initState() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        _keyboardVisible = visible;
      },
    );
    super.initState();
  }

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
                Visibility(
                  visible: !_keyboardVisible,
                  child: Padding(
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
                ),
                Villain(
                  villainAnimation: VillainAnimation.fromBottom(
                    relativeOffset: 0.4,
                  ),
                  secondaryVillainAnimation: VillainAnimation.fade(),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Form(
                          key: _emailKey,
                          child: TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              if (!EmailValidator.validate(value)) {
                                return 'Please enter a valid email.';
                              } else if (_emailValidator != null) {
                                return _emailValidator;
                              }
                              return null;
                            },
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
                            controller: _passwordController,
                            validator: (value) {
                              if (value.length < 6) {
                                return 'The password must be 6 characters long or more.';
                              } else if (_passwordValidator != null) {
                                return _passwordValidator;
                              }
                              return null;
                            },
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
                Villain(
                  villainAnimation: VillainAnimation.fade(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _isLoading
                        ? SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ))
                        : IconButton(
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              if (_emailKey.currentState.validate() &&
                                  _passwordKey.currentState.validate()) {
                                try {
                                  final firebaseUser = await signInWithEmail(
                                      _emailController.text.trim(),
                                      _passwordController.text);
                                  FocusScope.of(context).unfocus();
                                  final RemoteConfigSetup remoteConfigSetup =
                                      Provider.of<RemoteConfigSetup>(context);
                                  runApp(MultiProvider(providers: [
                                    Provider.value(
                                      value: remoteConfigSetup,
                                    ),
                                    StreamProvider<User>(
                                        initialData:
                                            User.base(remoteConfigSetup),
                                        builder: (_) => UserService()
                                            .streamUser(firebaseUser)),
                                  ], child: RootApp()));
                                } catch (error) {
                                  switch ((error as PlatformException).code) {
                                    case 'ERROR_INVALID_EMAIL':
                                      setState(() {
                                        _emailValidator = 'Email malformed.';
                                        _emailKey.currentState.validate();
                                        _emailValidator = null;
                                      });
                                      break;
                                    case 'ERROR_WRONG_PASSWORD':
                                    case 'ERROR_USER_NOT_FOUND':
                                      setState(() {
                                        _emailValidator = '';
                                        _passwordValidator =
                                            'Email or password incorrect.';
                                        _emailKey.currentState.validate();
                                        _passwordKey.currentState.validate();
                                        _emailValidator = null;
                                        _passwordValidator = null;
                                      });
                                      break;
                                    default:
                                      setState(() {
                                        _emailValidator = '';
                                        _passwordValidator = '';
                                        _emailKey.currentState.validate();
                                        _passwordKey.currentState.validate();
                                        _emailValidator = null;
                                        _passwordValidator = null;
                                      });
                                      break;
                                  }
                                }
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            }),
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
