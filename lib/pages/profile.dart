import 'package:advance/components/user.dart';
import 'package:advance/firebase/user_service.dart';
import 'package:advance/styleguide.dart';
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          labelColor: Colors.black,
          indicatorColor: Colors.black.withOpacity(0.17),
          tabs: <Widget>[
            Tab(
              text: "Me",
            ),
            Tab(
              text: "Friends",
            )
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            Container(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
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
                ],
              ),
            ),
            Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {}, label: Text('Add Friend')),
            )
          ],
        ),
      ),
    );
  }
}
