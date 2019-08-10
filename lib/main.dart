import 'package:advance/components/ui_elements_icons.dart';
import 'package:advance/pages/achievements.dart';
import 'package:advance/pages/progress.dart';
import 'package:advance/pages/shop.dart';
import 'package:advance/pages/train.dart';
import 'package:advance/screens/welcome/welcome.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';

void main() {
  runApp(MaterialApp(
    navigatorObservers: [new VillainTransitionObserver()],
    theme: ThemeData(primarySwatch: Colors.blue),
    home: WelcomeScreen(),
    //home: MainController()
  ));
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
    Progress(
      key: PageStorageKey("progress"),
    ),
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
                '1',
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
                '100',
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
                title: Text("Progress")),
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
                title: Text("Achievements")),
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
