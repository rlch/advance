enum ShopCategory { workouts, powerUps }

class ShopItem {
  ShopCategory shopCategory;
  String name;
  String description;
  String iconPath;
  int price;

  ShopItem(
      {this.shopCategory,
      this.name,
      this.description,
      this.iconPath,
      this.price});

  factory ShopItem.fromConfig(Map data) {
    ShopCategory _stringToEnum(String shopCategory) {
      switch (shopCategory) {
        case "workouts":
          return ShopCategory.workouts;
        case "power_ups":
          return ShopCategory.powerUps;
      }
      return null;
    }

    return ShopItem(
        shopCategory: _stringToEnum(data['shop_category']),
        name: data['name'],
        description: data['description'],
        iconPath: data['icon_path'],
        price: data['price']);
  }
}
