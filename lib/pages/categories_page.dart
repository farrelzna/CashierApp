import 'package:flutter/material.dart';
import 'package:project_nganggur/pages/cashier_page.dart';
import 'package:project_nganggur/models/menu_data.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  // Color constants
  static const Color primaryColor = Color(0xFF1A1817);
  static const Color accentColor = Color(0xFFBFA780);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Heavy Food',
      'icon': Icons.restaurant_menu,
      'color': Color(0xFF8C7B6B),
    },
    {
      'name': 'Snacks',
      'icon': Icons.bakery_dining,
      'color': Color(0xFFAD8174),
    },
    {
      'name': 'Desserts',
      'icon': Icons.cake,
      'color': Color(0xFFD4AF37),
    },
    {
      'name': 'Coffee',
      'icon': Icons.coffee,
      'color': Color(0xFF6F4E37),
    },
    {
      'name': 'Drinks',
      'icon': Icons.local_drink,
      'color': Color(0xFF7B9EA8),
    },
    {
      'name': 'Mocktails',
      'icon': Icons.wine_bar,
      'color': Color(0xFFC5708C),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int getItemCount(String category) {
    return MenuData.getMenuItems(category).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: const Text(
          "Menu Categories",
          style: TextStyle(
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
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final itemCount = getItemCount(category['name']);
              return InkWell(
                onTap: () {
                  _animationController.reverse().then((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CashierPage(
                          selectedCategory: category[
                              'name'], // Use the category name from the data
                        ),
                      ),
                    ).then((_) => _animationController.forward());
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: category['color'].withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          category['icon'],
                          size: 32,
                          color: category['color'],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        category['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$itemCount items',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
