import 'package:flutter/material.dart';
//import 'package:Tifnova/screens/payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> selectedAddress;
  const PaymentScreen({Key? key, required this.selectedAddress})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final Color primaryColor = const Color(0xFF870474);
  String? selectedPaymentMethod;

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'name': 'Debit / Credit card',
      'icon': Icons.credit_card,
      'color': Colors.indigo,
      'logo': 'assets/icons/card.png',
    },
    {
      'name': 'Internet Banking',
      'icon': Icons.account_balance,
      'color': Colors.blue,
      'logo': 'assets/icons/bank.png',
    },
    {
      'name': 'Google Pay',
      'icon': Icons.account_balance_wallet,
      'color': Colors.black,
      'logo': 'assets/icons/google_pay.png',
    },
    {
      'name': 'PhonePe',
      'icon': Icons.phone_android,
      'color': Colors.purple,
      'logo': 'assets/icons/phonepe.png',
    },
    {
      'name': 'Rupay',
      'icon': Icons.credit_card,
      'color': Colors.orange,
      'logo': 'assets/icons/rupay.png',
    },
    {
      'name': 'UPI',
      'icon': Icons.money,
      'color': Colors.blue,
      'logo': 'assets/icons/upi.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Payment Option",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // Address Summary
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Delivering to:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(widget.selectedAddress["name"],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(widget.selectedAddress["mobile"]),
                const SizedBox(height: 4),
                Text(widget.selectedAddress["address"],
                    style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text("Change Address"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryColor,
                    side: BorderSide(color: primaryColor),
                    minimumSize: const Size(double.infinity, 40),
                  ),
                ),
              ],
            ),
          ),
          // Payment Methods
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...paymentMethods.map((method) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildPaymentMethod(method),
                    )),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("Add another payment option"),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[400]!),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: selectedPaymentMethod != null
                ? () => _showPaymentSuccessPopup()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("PAY NOW",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(Map<String, dynamic> method) {
    final isSelected = selectedPaymentMethod == method['name'];
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? primaryColor : Colors.grey[200]!,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: ListTile(
        leading: method.containsKey('logo')
            ? Image.asset(method['logo'], height: 24)
            : Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: method['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(method['icon'], color: method['color']),
              ),
        title: Text(method['name']),
        trailing:
            isSelected ? Icon(Icons.check_circle, color: primaryColor) : null,
        onTap: () => setState(() => selectedPaymentMethod = method['name']),
      ),
    );
  }

  void _showPaymentSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Animation/Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle,
                      size: 60, color: Colors.green[700]),
                ),
                const SizedBox(height: 20),

                // Success Message
                const Text(
                  "Payment Successful!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  "Your order has been placed successfully",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Order Details
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow("Order ID", "#123456789"),
                      const SizedBox(height: 8),
                      _buildDetailRow("Payment Method", selectedPaymentMethod!),
                      const SizedBox(height: 8),
                      _buildDetailRow("Delivery Address",
                          "${widget.selectedAddress["name"]}, ${widget.selectedAddress["address"]}"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Close button (auto-closes after 3 seconds)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToOrderPage();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("VIEW ORDER",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Auto-close after 3 seconds
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        Navigator.pop(context);
        _navigateToOrderPage();
      }
    });
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              )),
        ),
        const Text(": "),
        Expanded(
          child: Text(value, style: TextStyle(color: Colors.grey[800])),
        ),
      ],
    );
  }

  void _navigateToOrderPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderTrackingScreen(
          address: widget.selectedAddress,
          paymentMethod: selectedPaymentMethod!,
        ),
      ),
    );
  }
}

// Order Tracking Screen
class OrderTrackingScreen extends StatelessWidget {
  final Map<String, dynamic> address;
  final String paymentMethod;

  const OrderTrackingScreen({
    Key? key,
    required this.address,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Tracking"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Order Status
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[50],
              child: Column(
                children: [
                  const Text("Order Placed Successfully!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 8),
                  Text("Order ID: #123456789",
                      style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: 0.3, // 30% completed (order placed)
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Order Placed", style: TextStyle(fontSize: 12)),
                      Text("Preparing", style: TextStyle(fontSize: 12)),
                      Text("On the way", style: TextStyle(fontSize: 12)),
                      Text("Delivered", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),

            // Order Details
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Order Details",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildDetailCard(
                    title: "Delivery Address",
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(address["name"],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(address["mobile"]),
                        const SizedBox(height: 4),
                        Text(address["address"],
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailCard(
                    title: "Payment Method",
                    content: Text(paymentMethod),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailCard(
                    title: "Order Summary",
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildOrderItem("Item 1", 1, 120),
                        _buildOrderItem("Item 2", 2, 80),
                        const Divider(),
                        _buildOrderTotal("Subtotal", 280),
                        _buildOrderTotal("Delivery Charge", 20),
                        _buildOrderTotal("Total", 300, isBold: true),
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

  Widget _buildDetailCard({required String title, required Widget content}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(String name, int quantity, double price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(name)),
          Text("×$quantity"),
          Text("₹${price * quantity}"),
        ],
      ),
    );
  }

  Widget _buildOrderTotal(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label,
              style:
                  isBold ? const TextStyle(fontWeight: FontWeight.bold) : null),
          const Spacer(),
          Text("₹$amount",
              style:
                  isBold ? const TextStyle(fontWeight: FontWeight.bold) : null),
        ],
      ),
    );
  }
}
