import 'package:flutter/material.dart';
import 'models/cart_item.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItem> selectedItems;
  final double totalAmount;
  final VoidCallback onPaymentComplete;

  const CheckoutPage({
    super.key,
    required this.selectedItems,
    required this.totalAmount,
    required this.onPaymentComplete,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Updated color constants for luxury minimalist theme
  static const Color primaryColor = Color(0xFF1A1817); // Rich Black
  static const Color accentColor = Color(0xFFBFA780); // Champagne Gold
  static const Color backgroundColor = Color(0xFFF8F8F8); // Soft White
  static const Color textColor = Color(0xFF2D2D2D); // Charcoal
  static const Color secondaryColor = Color(0xFF8C7B6B); // Warm Taupe
  static const Color cardColor = Colors.white;

  final TextEditingController _cashController = TextEditingController();
  String _selectedPaymentMethod = 'Cash';
  double change = 0;

  // Add payment methods with their respective fees
  final Map<String, double> paymentMethods = {
    'Cash': 0,
    'M-Banking': 1000,
    'DANA': 500,
    'OVO': 500,
    'GoPay': 500,
  };

  // Tax percentage
  final double taxRate = 0.1; // 11% tax

  // Calculate total with fees
  double getTotalWithFees() {
    double adminFee = paymentMethods[_selectedPaymentMethod] ?? 0;
    double tax = widget.totalAmount * taxRate;
    return widget.totalAmount + adminFee + tax;
  }

  @override
  Widget build(BuildContext context) {
    double finalTotal = getTotalWithFees();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: cardColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Complete Your Order",
          style: TextStyle(
            color: cardColor,
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: widget.selectedItems.length,
              itemBuilder: (context, index) {
                final item = widget.selectedItems[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
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
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: Image.asset(
                          item.image,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: accentColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    item.category,
                                    style: TextStyle(
                                      color: accentColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildOrderDetail(
                                      "Price", "Rp ${item.price}"),
                                  Container(
                                    height: 24,
                                    width: 1,
                                    color: secondaryColor.withOpacity(0.2),
                                  ),
                                  _buildOrderDetail(
                                      "Quantity", "${item.quantity}x"),
                                  Container(
                                    height: 24,
                                    width: 1,
                                    color: secondaryColor.withOpacity(0.2),
                                  ),
                                  _buildOrderDetail(
                                    "Subtotal",
                                    "Rp ${item.price * item.quantity}",
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
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildPaymentRow("Subtotal", widget.totalAmount),
                          const SizedBox(height: 8),
                          _buildPaymentRow(
                              "Tax (11%)", widget.totalAmount * taxRate),
                          const SizedBox(height: 8),
                          _buildPaymentRow(
                            "Service Fee",
                            paymentMethods[_selectedPaymentMethod] ?? 0,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(),
                          ),
                          _buildPaymentRow("Total", finalTotal, isTotal: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: (_selectedPaymentMethod == 'Cash' &&
                              change < 0)
                          ? null
                          : () {
                              // Handle payment completion
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Payment Successful via $_selectedPaymentMethod!",
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              widget.onPaymentComplete(); // Call the callback
                              Navigator.pop(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Complete Order • Rp ${finalTotal.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetail(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: secondaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? textColor : secondaryColor,
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        Text(
          "Rp ${amount.toStringAsFixed(0)}",
          style: TextStyle(
            color: isTotal ? accentColor : textColor,
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
