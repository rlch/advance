import 'dart:async';

import 'package:advance/components/scroll_behaviour.dart';
import 'package:advance/components/ui_elements_icons.dart';
import 'package:advance/components/user.dart';
import 'package:advance/screens/premium_slider.dart';
import 'package:cache_image/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import '../components/shop_items.dart';

class Shop extends StatefulWidget {
  Shop({Key key}) : super(key: key);

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  StreamSubscription<List<PurchaseDetails>> _subscription;
  bool inAppAvailable = false;

  @override
  void initState() {
    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) {
      //_handlePurchaseUpdates(purchases);
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  List<Widget> _buildShop(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final shopItems = Provider.of<List<ShopItem>>(context);
    final user = Provider.of<User>(context);

    List<Widget> shop = [];
    shop.add(Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: user.appTheme.gradientColors,
              stops: [0.05, 1],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Advance ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      ),
                      Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Text(' + ', style: TextStyle(color: user.appTheme.themeColor.primary, fontSize: 20, fontWeight: FontWeight.w900)),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Create unlimited workouts, compete with your friends, earn energy for achievements, unlock more workouts and more!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return PremiumSliderScreen();
                      }));
                    },
                    child: Text("TRY FOR FREE"),
                    color: Colors.white,
                    textColor: user.appTheme.themeColor.primary,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));

    InAppPurchaseConnection.instance
        .isAvailable()
        .then((isAvailable) => inAppAvailable = isAvailable);

    String _getShopCategoryString(ShopCategory shopCategory) {
      switch (shopCategory) {
        case ShopCategory.workouts:
          return "Workouts";
        case ShopCategory.powerUps:
          return "Power-Ups";
        default:
          return "";
      }
    }

    void _showDialog(ShopItem item) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Text('Get ${item.name} for ${item.price} energy?'),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("Get"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }

    for (final shopCategory in ShopCategory.values) {
      shop.add(Padding(
        padding: EdgeInsets.only(top: 20, left: 30, bottom: 5),
        child: Row(
          children: <Widget>[
            Text(
              _getShopCategoryString(shopCategory),
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: "WorkSans"),
            ),
          ],
        ),
      ));

      for (final shopItem in shopItems) {
        if (shopItem.shopCategory == shopCategory) {
          shop.add(Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: InkWell(
              onTap: () {
                _showDialog(shopItem);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                    //border: Border.all(
                    //    color: Colors.black.withOpacity(0.1), width: 3),
                    borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CacheImage.firebase(
                      prefix: 'gs://advance-72a11.appspot.com/',
                      path: shopItem.iconPath,
                      width: screenWidth * 0.2,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              shopItem.name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  fontFamily: "WorkSans"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              shopItem.description,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: "WorkSans"),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(UiElements.energy),
                                tooltip: 'Balance',
                                onPressed: () {},
                                color: Colors.blue,
                              ),
                              Text(
                                shopItem.price.toString(),
                                style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                    color: Colors.blue),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
        }
      }
    }
    return shop;
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: BlankScrollBehaviour(),
      child: SingleChildScrollView(
        child: Column(
          children: _buildShop(context),
        ),
      ),
    );
  }
}
