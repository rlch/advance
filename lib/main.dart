import 'package:advance/components/ui_elements_icons.dart';
import 'package:advance/firebase/user_service.dart';
import 'package:advance/pages/achievements.dart';
import 'package:advance/pages/profile.dart';
import 'package:advance/pages/shop.dart';
import 'package:advance/pages/train.dart';
import 'package:advance/screens/welcome/welcome.dart';
import 'package:advance/styleguide.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'components/user.dart';
import 'firebase/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';

void main() async {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  FirebaseUser firebaseUser = await checkAuthStatus();

  if (firebaseUser == null) {
    runApp(MaterialApp(
      navigatorObservers: [
        new VillainTransitionObserver(),
        FirebaseAnalyticsObserver(analytics: analytics)
      ],
      theme: AppTheme.rootTheme,
      home: WelcomeScreen(),
    ));
  } else {
    runApp(MultiProvider(providers: [
      StreamProvider<User>(
          initialData: User.base(),
          builder: (_) => UserService().streamUser(firebaseUser)),
    ], child: RootApp()));
  }
}

class RootApp extends StatefulWidget {
  RootApp({Key key}) : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(navigatorObservers: [
      new VillainTransitionObserver(),
      FirebaseAnalyticsObserver(analytics: analytics)
    ], theme: Provider.of<User>(context).appTheme.mainTheme, home: MainController());
  }
}

class MainController extends StatefulWidget {
  MainController({Key key}) : super(key: key);

  @override
  _MainControllerState createState() => _MainControllerState();
}

class _MainControllerState extends State<MainController> {
  int currentPageIndex;
  final PageStorageBucket bucket = PageStorageBucket();
  List<Widget> pages = [
    Train(
      key: PageStorageKey("train"),
    ),
    Profile(),
    Achievements(
      key: PageStorageKey("achievements"),
    ),
    Shop(
      key: PageStorageKey("shop"),
    )
  ];

  @override
  void initState() {
    super.initState();
    currentPageIndex = 0;
  }

  void changePage(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    var bubbleItems = <BubbleBottomBarItem>[
      BubbleBottomBarItem(
          backgroundColor: user.appTheme.themeColor.dark,
          icon: Icon(
            UiElements.home_active,
            color: user.appTheme.iconGrey,
          ),
          activeIcon: Icon(
            UiElements.home_active,
            color: user.appTheme.themeColor.dark,
          ),
          title: Text("Home")),
      BubbleBottomBarItem(
          backgroundColor: user.appTheme.themeColor.dark,
          icon: Icon(
            UiElements.progress,
            color: user.appTheme.iconGrey,
          ),
          activeIcon: Icon(
            UiElements.progress,
            color: user.appTheme.themeColor.dark,
          ),
          title: Text("Profile")),
      BubbleBottomBarItem(
          backgroundColor: user.appTheme.themeColor.dark,
          icon: Icon(
            UiElements.trophy_active,
            color: user.appTheme.iconGrey,
          ),
          activeIcon: Icon(
            UiElements.trophy_active,
            color: user.appTheme.themeColor.dark,
          ),
          title: Text("Goals")),
      BubbleBottomBarItem(
          backgroundColor: user.appTheme.themeColor.dark,
          icon: Icon(
            UiElements.shop,
            color: user.appTheme.iconGrey,
          ),
          activeIcon: Icon(
            UiElements.shop,
            color: user.appTheme.themeColor.dark,
          ),
          title: Text("Shop"))
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                      icon: Icon(UiElements.fire),
                      tooltip: 'Streak',
                      onPressed: () {},
                      color: Colors.red),
                  Text(
                    user.streak.current.toString(),
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                        color: Colors.red),
                  ),
                ],
              ),
              SizedBox(
                width: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(UiElements.energy),
                    tooltip: 'Balance',
                    onPressed: () {},
                    color: Colors.blue,
                  ),
                  Text(
                    user.energy.toString(),
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Colors.blue),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                  )
                ],
              ),
            ]),
      ),
      floatingActionButton: Visibility(
        visible: (currentPageIndex == 0),
        child: FloatingActionButton(
          backgroundColor: user.appTheme.themeColor.dark,
          onPressed: () {},
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: (currentPageIndex == 0)
            ? BubbleBottomBar(
                fabLocation: BubbleBottomBarFabLocation.end,
                hasNotch: true,
                hasInk: true,
                opacity: .2,
                currentIndex: currentPageIndex,
                onTap: changePage,
                elevation: 0,
                items: bubbleItems,
              )
            : BubbleBottomBar(
                hasNotch: true,
                hasInk: true,
                opacity: .2,
                currentIndex: currentPageIndex,
                onTap: changePage,
                elevation: 0,
                items: bubbleItems,
              ),
      ),
      body: PageStorage(
        child: pages[currentPageIndex],
        bucket: bucket,
      ),
    );
  }
}
