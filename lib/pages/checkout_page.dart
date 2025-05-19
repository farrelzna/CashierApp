
import 'package:flutter/material.dart';
import 'package:project_nganggur/models/cart_item.dart';
import 'package:project_nganggur/services/receipt_page.dart';  // Add this import

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selected Items Section
                  Text(
                    "Selected Items (${widget.selectedItems.length})",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                        child: Row(
                          children: [
                            // Square image
                            ClipRRect(
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(16),
                              ),
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.asset(
                                  item.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Item details
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: accentColor.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                    const SizedBox(height: 8),
                                    Text(
                                      "Base Price: Rp ${item.price}",
                                      style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Quantity: ${item.quantity}x",
                                          style: TextStyle(
                                            color: secondaryColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          "Rp ${item.price * item.quantity}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Payment Details Section
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(16),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Payment Details",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Payment Method Card First
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Payment Method",
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: secondaryColor.withOpacity(0.2)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: _selectedPaymentMethod,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 16,
                                    ),
                                    items: paymentMethods.keys
                                        .map((String method) {
                                      return DropdownMenuItem<String>(
                                        value: method,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(method),
                                            if (paymentMethods[method]! > 0)
                                              Text(
                                                '+ Rp ${paymentMethods[method]!.toStringAsFixed(0)}',
                                                style: TextStyle(
                                                  color: secondaryColor,
                                                  fontSize: 14,
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedPaymentMethod = newValue!;
                                        if (newValue == 'Cash') {
                                          _cashController.clear();
                                          change = 0;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              if (_selectedPaymentMethod == 'Cash') ...[
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _cashController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Cash Amount',
                                    prefixText: 'Rp ',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      double cashAmount =
                                          double.tryParse(value) ?? 0;
                                      change = cashAmount - getTotalWithFees();
                                    });
                                  },
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Change',
                                      style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'Rp ${change.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        color: change >= 0
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Payment Details Card Second
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
                              _buildPaymentRow("Total", finalTotal,
                                  isTotal: true),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Full Width Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
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
                                    
                                    // Navigate to receipt page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReceiptPage(
                                          items: widget.selectedItems,
                                          totalAmount: finalTotal,
                                          paymentMethod: _selectedPaymentMethod,
                                          cashAmount: _selectedPaymentMethod == 'Cash' 
                                              ? double.tryParse(_cashController.text) ?? 0 
                                              : finalTotal,
                                          change: change,
                                        ),
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              "Complete Order • Rp ${finalTotal.toStringAsFixed(0)}",
                              style: const TextStyle(
                                color:
                                    backgroundColor, // Changed to textColor (black)
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.5,
                              ),
                            ),
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
