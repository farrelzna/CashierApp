import 'package:flutter/material.dart';
import '../pages/checkout_page.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';
import '../models/menu_data.dart';

class CashierPage extends StatefulWidget {
  final Function()? onCheckoutComplete;
  final String? selectedCategory;

  const CashierPage({
    super.key,
    this.onCheckoutComplete,
    this.selectedCategory,
  });

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage>
    with SingleTickerProviderStateMixin {
  // Add color constants
  static const Color primaryColor = Color(0xFF1A1817); // Rich Black
  static const Color accentColor = Color.fromARGB(255, 167, 167, 167); // Gold
  static const Color backgroundColor = Color(0xFFF5F5F5); // Off-white
  static const Color secondaryColor = Color(0xFF8C7B6B); // Warm Taupe
  static const Color cardColor = Colors.white;

  final TextEditingController searchController = TextEditingController();

  // Update product list initialization
  late final List<MenuItem> _products;
  late List<MenuItem> _foundProducts;

  // Tambahkan Map untuk menyimpan quantity setiap item
  final Map<int, int> _itemQuantities = {};

  // Add animation controller and animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Create fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    // Start the animation
    _animationController.forward();

    // Initialize products based on selected category
    _products = MenuData.getMenuItems(widget.selectedCategory);
    _foundProducts = _products;
  }

  @override
  void dispose() {
    searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Fungsi untuk melakukan pencarian
  void _runFilter(String enteredKeyword) {
    List<MenuItem> results = [];
    if (enteredKeyword.isEmpty) {
      results = _products;
    } else {
      results = _products
          .where((product) =>
              product.name
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              product.category
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

  // Update the _handleCheckout method
  void _handleCheckout() {
    if (getTotalItems() > 0) {
      // Start fade out animation
      _animationController.reverse().then((_) {
        final selectedItems = _itemQuantities.entries
            .where((entry) => entry.value > 0)
            .map((entry) {
          final product = _products[entry.key];
          return CartItem(
            name: product.name,
            category: product.category,
            price: product.price,
            image: product.image,
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
                  _itemQuantities.clear();
                  _foundProducts = _products;
                });
                if (widget.onCheckoutComplete != null) {
                  widget.onCheckoutComplete!();
                }
                // Fade back in when returning
                _animationController.forward();
              },
            ),
          ),
        ).then((_) {
          // Fade back in when returning without completing payment
          _animationController.forward();
        });
      });
    }
  }

  // Modify _buildMenuSection to include fade animation
  Widget _buildMenuSection(String category, List<MenuItem> items) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              category,
              style: TextStyle(
                color: secondaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final product = items[index];
              final globalIndex = _products.indexOf(product);
              final quantity = _itemQuantities[globalIndex] ?? 0;

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
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Image Container with fixed 1:1 aspect ratio
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(15),
                        ),
                        child: Container(
                          width: 100, // Fixed width
                          height:
                              100, // Fixed height - same as width for 1:1 ratio
                          decoration: BoxDecoration(
                            color: Colors
                                .grey[200], // Fallback color while image loads
                          ),
                          child: Image.asset(
                            product.image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Product Details
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical:
                                12, // Reduced vertical padding to match image height
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Rp ${product.price}',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Quantity Controls
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
                                        icon: const Icon(
                                          Icons.remove,
                                          color: cardColor,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (_itemQuantities[globalIndex]! >
                                                0) {
                                              _itemQuantities[globalIndex] =
                                                  _itemQuantities[
                                                          globalIndex]! -
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
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
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
                                      icon: const Icon(
                                        Icons.add,
                                        color: cardColor,
                                        size: 20,
                                      ),
                                      onPressed: () => _addItem(globalIndex),
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
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        leading: widget.selectedCategory != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: cardColor),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          widget.selectedCategory ?? "All Menu",
          style: const TextStyle(
            color: cardColor,
            fontSize: 24,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
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
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.selectedCategory != null)
                              _buildMenuSection(
                                widget.selectedCategory!,
                                _foundProducts,
                              )
                            else ...[
                              _buildMenuSection(
                                'Heavy Food',
                                _foundProducts
                                    .where((product) =>
                                        product.category == 'Heavy Food')
                                    .toList(),
                              ),
                              _buildMenuSection(
                                'Snacks',
                                _foundProducts
                                    .where((product) =>
                                        product.category == 'Snacks')
                                    .toList(),
                              ),
                              _buildMenuSection(
                                'Desserts',
                                _foundProducts
                                    .where((product) =>
                                        product.category == 'Desserts')
                                    .toList(),
                              ),
                              _buildMenuSection(
                                'Coffee',
                                _foundProducts
                                    .where((product) =>
                                        product.category == 'Coffee')
                                    .toList(),
                              ),
                              _buildMenuSection(
                                'Drinks',
                                _foundProducts
                                    .where((product) =>
                                        product.category == 'Drinks')
                                    .toList(),
                              ),
                              _buildMenuSection(
                                'Mocktails',
                                _foundProducts
                                    .where((product) =>
                                        product.category == 'Mocktails')
                                    .toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FadeTransition(
        opacity: _fadeAnimation,
        child: getTotalItems() > 0
            ? Container(
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _handleCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        color: cardColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${getTotalItems()} items",
                        style: const TextStyle(
                          color: cardColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 1,
                        height: 20,
                        color: cardColor.withOpacity(0.3),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        "Checkout",
                        style: TextStyle(
                          color: cardColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
