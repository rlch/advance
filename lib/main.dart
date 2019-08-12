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
  FirebaseUser user = await checkAuthStatus();

  if (user == null) {
    runApp(MaterialApp(
      navigatorObservers: [
        new VillainTransitionObserver(),
        FirebaseAnalyticsObserver(analytics: analytics)
      ],
      theme: AppTheme.mainTheme,
      home: WelcomeScreen(),
    ));
  } else {
    runApp(
      MultiProvider(
          providers: [
            StreamProvider<User>(
                initialData: User.base(),
                builder: (_) => UserService().streamUser(user)),
          ],
          child: MaterialApp(navigatorObservers: [
            new VillainTransitionObserver(),
            FirebaseAnalyticsObserver(analytics: analytics)
          ], theme: AppTheme.mainTheme, home: MainController())),
    );
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
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        actions: <Widget>[
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
        ],
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,*/
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: BubbleBottomBar(
          hasNotch: false,
          hasInk: true,
          opacity: .2,
          currentIndex: currentPageIndex,
          onTap: changePage,
          elevation: 0,
          items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(
                backgroundColor: Colors.red,
                icon: Icon(
                  UiElements.home_active,
                  color: Colors.red,
                ),
                activeIcon: Icon(
                  UiElements.home_active,
                  color: Colors.red,
                ),
                title: Text("Home")),
            BubbleBottomBarItem(
                backgroundColor: Colors.deepPurple,
                icon: Icon(
                  UiElements.progress,
                  color: Colors.deepPurple,
                ),
                activeIcon: Icon(
                  UiElements.progress,
                  color: Colors.deepPurple,
                ),
                title: Text("Profile")),
            BubbleBottomBarItem(
                backgroundColor: Colors.orange,
                icon: Icon(
                  UiElements.trophy_active,
                  color: Colors.orange,
                ),
                activeIcon: Icon(
                  UiElements.trophy_active,
                  color: Colors.orange,
                ),
                title: Text("Goals")),
            BubbleBottomBarItem(
                backgroundColor: Colors.green,
                icon: Icon(
                  UiElements.shop,
                  color: Colors.green,
                ),
                activeIcon: Icon(
                  UiElements.shop,
                  color: Colors.green,
                ),
                title: Text("Shop"))
          ],
        ),
      ),
      body: PageStorage(
        child: pages[currentPageIndex],
        bucket: bucket,
      ),
    );
  }
}
