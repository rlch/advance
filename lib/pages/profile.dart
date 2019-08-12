import 'package:advance/styleguide.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
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
                onPressed: () {},
                label: Text('Add Friend')
              ),
            )
          ],
        ),
      ),
    );
  }
}
