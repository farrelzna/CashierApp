import 'menu_item.dart';

class MenuData {
  static List<MenuItem> getMenuItems(String? category) {
    final allItems = [
      // Heavy Food
      MenuItem(
        name: 'Nasi Goreng Special',
        category: 'Heavy Food',
        price: 25000,
        image: 'assets/images/nasgor.jpg',
      ),
      MenuItem(
        name: 'Mie Goreng Special',
        category: 'Heavy Food',
        price: 23000,
        image: 'assets/images/miegoreng.jpg',
      ),
      MenuItem(
        name: 'Beef Burger',
        category: 'Heavy Food',
        price: 35000,
        image: 'assets/images/burger.jpg',
      ),
      MenuItem(
        name: 'Chicken Steak',
        category: 'Heavy Food',
        price: 45000,
        image: 'assets/images/steak.jpg',
      ),
      MenuItem(
        name: 'Spaghetti Carbonara',
        category: 'Heavy Food',
        price: 38000,
        image: 'assets/images/carbonara.jpg',
      ),

      // Snacks
      MenuItem(
        name: 'French Fries',
        category: 'Snacks',
        price: 15000,
        image: 'assets/images/fries.jpg',
      ),
      MenuItem(
        name: 'Chicken Wings',
        category: 'Snacks',
        price: 20000,
        image: 'assets/images/wings.jpg',
      ),
      MenuItem(
        name: 'Cheese Nachos',
        category: 'Snacks',
        price: 25000,
        image: 'assets/images/nachos.jpg',
      ),
      MenuItem(
        name: 'Onion Rings',
        category: 'Snacks',
        price: 18000,
        image: 'assets/images/onionrings.jpg',
      ),
      MenuItem(
        name: 'Spring Rolls',
        category: 'Snacks',
        price: 16000,
        image: 'assets/images/springrolls.jpg',
      ),

      // Desserts
      MenuItem(
        name: 'Ice Cream Sundae',
        category: 'Desserts',
        price: 18000,
        image: 'assets/images/icecream.jpg',
      ),
      MenuItem(
        name: 'Chocolate Cake',
        category: 'Desserts',
        price: 22000,
        image: 'assets/images/cake.jpg',
      ),
      MenuItem(
        name: 'Tiramisu',
        category: 'Desserts',
        price: 28000,
        image: 'assets/images/tiramisu.jpg',
      ),
      MenuItem(
        name: 'Crème Brûlée',
        category: 'Desserts',
        price: 30000,
        image: 'assets/images/cremebrulee.jpg',
      ),
      MenuItem(
        name: 'Apple Pie',
        category: 'Desserts',
        price: 25000,
        image: 'assets/images/applepie.jpg',
      ),

      // Coffee
      MenuItem(
        name: 'Cappuccino',
        category: 'Coffee',
        price: 22000,
        image: 'assets/images/cappuccino.jpg',
      ),
      MenuItem(
        name: 'Café Latte',
        category: 'Coffee',
        price: 23000,
        image: 'assets/images/latte.jpg',
      ),
      MenuItem(
        name: 'Espresso',
        category: 'Coffee',
        price: 18000,
        image: 'assets/images/espresso.jpg',
      ),
      MenuItem(
        name: 'Mocha',
        category: 'Coffee',
        price: 25000,
        image: 'assets/images/mocha.jpg',
      ),
      MenuItem(
        name: 'Americano',
        category: 'Coffee',
        price: 20000,
        image: 'assets/images/americano.jpg',
      ),

      // Drinks
      MenuItem(
        name: 'Iced Lemon Tea',
        category: 'Drinks',
        price: 15000,
        image: 'assets/images/lemontea.jpg',
      ),
      MenuItem(
        name: 'Fresh Orange Juice',
        category: 'Drinks',
        price: 18000,
        image: 'assets/images/orange.jpg',
      ),
      MenuItem(
        name: 'Mango Smoothie',
        category: 'Drinks',
        price: 20000,
        image: 'assets/images/mango.jpg',
      ),
      MenuItem(
        name: 'Green Tea Latte',
        category: 'Drinks',
        price: 23000,
        image: 'assets/images/greentea.jpg',
      ),
      MenuItem(
        name: 'Strawberry Milkshake',
        category: 'Drinks',
        price: 25000,
        image: 'assets/images/strawberry.jpg',
      ),

      // Mocktails
      MenuItem(
        name: 'Virgin Mojito',
        category: 'Mocktails',
        price: 25000,
        image: 'assets/images/mojito.jpg',
      ),
      MenuItem(
        name: 'Shirley Temple',
        category: 'Mocktails',
        price: 23000,
        image: 'assets/images/shirley.jpg',
      ),
      MenuItem(
        name: 'Blue Ocean',
        category: 'Mocktails',
        price: 28000,
        image: 'assets/images/blueocean.jpg',
      ),
      MenuItem(
        name: 'Passion Fruit Punch',
        category: 'Mocktails',
        price: 26000,
        image: 'assets/images/passionfruit.jpg',
      ),
      MenuItem(
        name: 'Berry Sparkler',
        category: 'Mocktails',
        price: 27000,
        image: 'assets/images/berry.jpg',
      ),
    ];

    if (category != null) {
      return allItems.where((item) => item.category == category).toList();
    }
    return allItems;
  }
}
