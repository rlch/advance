import 'package:advance/components/scroll_behaviour.dart';
import 'package:advance/components/ui_elements_icons.dart';
import 'package:flutter/material.dart';
import '../components/shop_items.dart';

class Shop extends StatefulWidget {
  Shop({Key key}) : super(key: key);

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  List<Widget> _buildShop(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    List<Widget> shop = [];

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
                    Image.asset(
                      shopItem.iconPath,
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
        child: Container(
          child: Column(
            children: _buildShop(context),
          ),
        ),
      ),
    );
  }
}
