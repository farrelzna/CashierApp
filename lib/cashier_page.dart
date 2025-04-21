import 'package:flutter/material.dart';
import 'package:project_nganggur/checkout_page.dart';
import 'package:project_nganggur/models/cart_item.dart'; // Tambahkan import ini

class CashierPage extends StatefulWidget {
  final Function()? onCheckoutComplete;

  const CashierPage({
    super.key,
    this.onCheckoutComplete,
  });

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  // Add color constants
  static const Color primaryColor = Color(0xFF3E2723); // Deep Brown
  static const Color accentColor = Color(0xFFD4AF37); // Gold
  static const Color backgroundColor = Color(0xFFF5F5F5); // Off-white
  static const Color textColor = Color(0xFF2D2D2D); // Almost black
  static const Color secondaryColor = Color(0xFF8C7B6B); // Warm Taupe
  static const Color cardColor = Colors.white;

  final TextEditingController searchController = TextEditingController();

  // Menambahkan List Map untuk data dummy
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Nasi Goreng',
      'category': 'Makanan',
      'price': 12000,
      'image': 'assets/images/nasgor.jpg',
    },
    {
      'name': 'Es Teh',
      'category': 'Minuman',
      'price': 3000,
      'image': 'assets/images/esteh.jpg',
    },
    {
      'name': 'Mie Goreng',
      'category': 'Makanan',
      'price': 8000,
      'image': 'assets/images/miegoreng.jpg',
    },
    {
      'name': 'Es Jeruk',
      'category': 'Minuman',
      'price': 5000,
      'image': 'assets/images/esjeruk.jpg',
    },
    {
      'name': 'Ayam Goreng + Nasi',
      'category': 'Makanan',
      'price': 15000,
      'image': 'assets/images/ayamgoreng.jpg',
    },
  ];

  // Tambahkan variabel untuk menyimpan hasil pencarian
  List<Map<String, dynamic>> _foundProducts = [];

  // Tambahkan Map untuk menyimpan quantity setiap item
  final Map<int, int> _itemQuantities = {};

  @override
  void initState() {
    _foundProducts = _products;
    super.initState();
  }

  // Fungsi untuk melakukan pencarian
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _products;
    } else {
      results = _products
          .where((product) =>
              product['name']
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              product['category']
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundProducts = results;
    });
  }

  // Tambahkan fungsi untuk menghitung total item
  int getTotalItems() {
    return _itemQuantities.values.fold(0, (sum, quantity) => sum + quantity);
  }

  // Fungsi untuk menambah item
  void _addItem(int index) {
    setState(() {
      _itemQuantities[index] = (_itemQuantities[index] ?? 0) + 1;
    });
  }

  void _handleCheckout() {
    if (getTotalItems() > 0) {
      final selectedItems = _itemQuantities.entries
          .where((entry) => entry.value > 0)
          .map((entry) {
        final product = _products[entry.key];
        return CartItem(
          name: product['name'],
          category: product['category'],
          price: product['price'],
          image: product['image'],
          quantity: entry.value,
        );
      }).toList();

      final totalAmount = selectedItems.fold<double>(
        0,
        (sum, item) => sum + (item.price * item.quantity),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutPage(
            selectedItems: selectedItems,
            totalAmount: totalAmount,
            onPaymentComplete: () {
              setState(() {
                _itemQuantities.clear(); // Clear all selected items
                _foundProducts = _products; // Reset search results
              });
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: const Text(
          "Café Menu",
          style: TextStyle(
            color: cardColor,
            fontSize: 24,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search menu...",
                  hintStyle: TextStyle(
                    color: secondaryColor.withOpacity(0.5),
                    fontWeight: FontWeight.w300,
                  ),
                  prefixIcon: Icon(Icons.search, color: secondaryColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
                onChanged: (value) => _runFilter(value),
              ),
            ),
            const SizedBox(height: 20),
            // Menu Items
            Expanded(
              child: _foundProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            size: 64,
                            color: secondaryColor.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Menu item not available',
                            style: TextStyle(
                              fontSize: 18,
                              color: secondaryColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please try a different search',
                            style: TextStyle(
                              fontSize: 14,
                              color: secondaryColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _foundProducts.length,
                      itemBuilder: (context, index) {
                        final product = _foundProducts[index];
                        final quantity = _itemQuantities[index] ?? 0;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15),
                                ),
                                child: Image.asset(
                                  product['image'],
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['name'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  accentColor.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              product['category'],
                                              style: TextStyle(
                                                color: accentColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Rp ${product['price']}',
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: accentColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (quantity > 0) ...[
                                            IconButton(
                                              icon: const Icon(Icons.remove,
                                                  color: cardColor, size: 20),
                                              onPressed: () {
                                                setState(() {
                                                  if (_itemQuantities[index]! >
                                                      0) {
                                                    _itemQuantities[index] =
                                                        _itemQuantities[
                                                                index]! -
                                                            1;
                                                  }
                                                });
                                              },
                                              constraints: const BoxConstraints(
                                                minWidth: 40,
                                                minHeight: 30,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Text(
                                                '$quantity',
                                                style: const TextStyle(
                                                  color: cardColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                          IconButton(
                                            icon: const Icon(Icons.add,
                                                color: cardColor, size: 20),
                                            onPressed: () => _addItem(index),
                                            constraints: const BoxConstraints(
                                              minWidth: 40,
                                              minHeight: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton.extended(
            onPressed: _handleCheckout,
            backgroundColor: accentColor,
            label: const Text(
              "Checkout",
              style: TextStyle(
                color: cardColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            icon: const Icon(Icons.shopping_cart, color: cardColor),
          ),
          if (getTotalItems() > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${getTotalItems()}',
                  style: const TextStyle(
                    color: cardColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
