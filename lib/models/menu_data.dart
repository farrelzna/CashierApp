import 'menu_item.dart';

class MenuData {
  static List<MenuItem> getFoodItems() {
    return [
      MenuItem(
        name: 'Nasi Goreng',
        category: 'Makanan',
        price: 12000,
        image: 'assets/images/nasgor.jpg',
      ),
      MenuItem(
        name: 'Mie Goreng',
        category: 'Makanan',
        price: 8000,
        image: 'assets/images/miegoreng.jpg',
      ),
      MenuItem(
        name: 'Ayam Goreng + Nasi',
        category: 'Makanan',
        price: 15000,
        image: 'assets/images/ayamgoreng.jpg',
      ),
    ];
  }

  static List<MenuItem> getBeverageItems() {
    return [
      MenuItem(
        name: 'Es Teh',
        category: 'Minuman',
        price: 3000,
        image: 'assets/images/esteh.jpg',
      ),
      MenuItem(
        name: 'Es Jeruk',
        category: 'Minuman',
        price: 5000,
        image: 'assets/images/esjeruk.jpg',
      ),
    ];
  }

  static List<MenuItem> getAllItems() {
    return [...getFoodItems(), ...getBeverageItems()];
  }
}