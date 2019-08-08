enum ShopCategory {
  workouts,
  powerUps
}

class ShopItem {
  ShopCategory shopCategory;
  String name;
  String description;
  String iconPath;
  int price;

  ShopItem({this.shopCategory, this.name, this.description, this.iconPath, this.price});
}

List<ShopItem> shopItems = [
    ShopItem(
        shopCategory: ShopCategory.workouts,
        name: "Weights",
        description: "Test tes ifjaeorfijeo fijaeorfi jerofij eroifj t",
        price: 100,
        iconPath: 'assets/workout_cards/weights.png'),
    ShopItem(
        shopCategory: ShopCategory.workouts,
        name: "Weight loss",
        description: "Test test",
        price: 200,
        iconPath: 'assets/workout_cards/weight_loss.png'),
    ShopItem(
        shopCategory: ShopCategory.powerUps,
        name: "Bonfire",
        description: "errwer test",
        price: 250,
        iconPath: 'assets/shop/bonfire.png'),
    ShopItem(
        shopCategory: ShopCategory.powerUps,
        name: "Bonfire",
        description: "errwer test",
        price: 250,
        iconPath: 'assets/shop/bonfire.png'),
    ShopItem(
        shopCategory: ShopCategory.powerUps,
        name: "Bonfire",
        description: "errwer test",
        price: 250,
        iconPath: 'assets/shop/bonfire.png')
  ];