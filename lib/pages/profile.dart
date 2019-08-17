import 'package:advance/components/ui_elements_icons.dart';
import 'package:advance/components/user.dart';
import 'package:advance/components/user_follow.dart';
import 'package:advance/firebase/user_service.dart';
import 'package:advance/styleguide.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    TextEditingController _emailController = TextEditingController();

    print(user.following);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          labelColor: Colors.black,
          indicatorColor: Colors.black.withOpacity(0.17),
          tabs: <Widget>[
            GestureDetector(
              child: Tab(
                text: "Me",
              ),
            ),
            Tab(
              text: "Friends",
            )
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniStartTop,
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: FloatingActionButton(
                  child: Icon(
                    Icons.settings,
                  ),
                  onPressed: () {},
                  backgroundColor: Colors.grey,
                  mini: true,
                ),
              ),
              body: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    backgroundColor: user.appTheme.themeColor.primary,
                    radius: screenHeight * 0.04,
                    child: Icon(
                      Icons.person,
                      size: screenHeight * 0.04,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      user.firebaseUser.email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontFamily: "WorkSans",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(children: <Widget>[
                            Text(
                              'Weight',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(user.weight.toString() + 'kg')
                          ]),
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(children: <Widget>[
                            Text(
                              'Height',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(user.height.toString() + 'cm')
                          ]),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, left: 30),
                    child: Text(
                      'Theme',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontFamily: "WorkSans"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1,
                    ),
                    child: GridView.count(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        crossAxisCount: 4,
                        children: themeColors
                            .map((colors) => Center(
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      UserService().changeThemeColor(
                                          user.firebaseUser.uid,
                                          themeColors.indexOf(colors));
                                    },
                                    fillColor: colors.primary,
                                    shape: CircleBorder(),
                                  ),
                                ))
                            .toList()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, left: 30),
                    child: Text(
                      'Daily Goal',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontFamily: "WorkSans"),
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(20),
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                            color: Colors.white,
                            border: Border.all(color: Colors.white, width: 2)),
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              user.streak.target = 1;
                            });
                          },
                          title: Text(
                            "Casual",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: (user.streak.target == 1)
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
                                left: BorderSide(color: Colors.white, width: 2),
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
                              user.streak.target = 2;
                            });
                          },
                          title: Text(
                            "Hero",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: (user.streak.target == 2)
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
                            border: Border.all(color: Colors.white, width: 2)),
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              user.streak.target = 3;
                            });
                          },
                          title: Text(
                            "Legend",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: (user.streak.target == 3)
                                    ? Colors.pink
                                    : Colors.black),
                          ),
                          trailing: Text('3 workouts a day'),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  return showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            content: TextField(
                              controller: _emailController,
                              decoration:
                                  InputDecoration(hintText: "Friend's email"),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: new Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: new Text('Submit'),
                                onPressed: () async {
                                  final HttpsCallable checkEmail =
                                      CloudFunctions.instance.getHttpsCallable(
                                    functionName: 'followUser',
                                  );
                                  try {
                                    dynamic res = await checkEmail.call({
                                      'email': _emailController.text.trim()
                                    });
                                    if (user.following == null) {
                                      user.following = {};
                                    }
                                    print(res);
                                     setState(() {
                                      user.following[res.data['uid']] =
                                          UserFollow.fromMap(
                                              res.data['uid'], res.data);
                                    });
                                    await UserService().follow(
                                        res.data['uid'], user.firebaseUser.uid);
                                  } catch (e) {
                                    print(e);
                                  }
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ));
                },
                label: Text('Add Friend'),
                backgroundColor: user.appTheme.themeColor.primary,
              ),
              body: ListView.builder(
                itemCount: user.following?.length ?? 0,
                itemBuilder: (context, index) {
                  String slug = user.following.keys.toList()[index];
                  print(user.following[slug].email);
                  return ListTile(
                    title: Text(
                      user.following[slug].nickname ??
                          user.following[slug].email,
                      style: TextStyle(fontSize: 20),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: user.appTheme.themeColor.primary,
                      child: Icon(Icons.person),
                    ),
                    trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(UiElements.fire),
                            tooltip: 'Streak',
                            onPressed: () {},
                            color: Colors.red),
                        Text(
                          user.following[slug].streak.toString(),
                          style: TextStyle(
                              fontFamily: 'WorkSans',
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
