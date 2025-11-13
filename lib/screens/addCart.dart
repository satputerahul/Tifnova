import 'package:flutter/material.dart';

class AddToCart extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  final double totalPrice;
  final List<Map<String, String>> similarMeals;

  const AddToCart({
    super.key,
    required this.selectedItems,
    required this.totalPrice,
    required this.similarMeals,
  });

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  final Color primaryPurple = const Color(0xFF870474);

  // --- Helper to parse price ---
  double _parsePrice(String priceString) {
    String numericPrice = priceString.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(numericPrice) ?? 0.0;
  }

  // --- 1. Empty Cart Widget ---
  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon/Image for Empty State
            Image.asset(
              'assets/icons/empty_cart.png',
              height: 150,
              width: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              "Your Cart is Empty!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Looks like you haven't added any meals yet.",
              style: TextStyle(fontSize: 15, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Button to navigate back to the home screen
            ElevatedButton(
              onPressed: () {
                // Navigate back to the previous screen (MessMenuScreen) or the home screen
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: const Text(
                "Browse Meals",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // --- END Empty Cart Widget ---

  // --- Cart Item Widget ---
  Widget _buildCartItem(Map<String, dynamic> item) {
    final price = _parsePrice(item['price'].toString());
    final quantity = item['quantity'] as int;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              item["image"],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item["dishName"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "₹ ${price.toStringAsFixed(0)}",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                // Display quantity like in the screenshot
                Text(
                  "Qty: $quantity",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          // Quantity Selector from the screenshot
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () {}, // Handle decrease quantity
                  child: const Text(
                    '-',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '$quantity',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {}, // Handle increase quantity
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: primaryPurple,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () {}, // Handle item deletion
            child: const Icon(Icons.delete_outline, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // --- Similar Meal Card Widget ---
  // (Keep _buildSimilarMealCard as is)
  Widget _buildSimilarMealCard(Map<String, String> mess) {
  return Container(
    width: 180,
    margin: const EdgeInsets.only(right: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 6,
          spreadRadius: 2,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.asset(
            mess['image']!,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      mess['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  Text(
                    mess['rating']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                mess['description']!,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.grey, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    mess['time']!,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const Text(" • ", style: TextStyle(color: Colors.grey)),
                  const Icon(Icons.delivery_dining, color: Colors.grey, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    mess['delivery']!,
                    style: TextStyle(
                      fontSize: 13,
                      color: mess['delivery'] == 'Free'
                            ? Colors.green : Colors.grey,
                      ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  // --- Main Build Method ---
  @override
  Widget build(BuildContext context) {
    final bool isCartEmpty = widget.selectedItems.isEmpty;
    // final singleCartItem = isCartEmpty ? null : widget.selectedItems.first;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('assets/icons/back.png', width: 30, height: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Cart",
          style: TextStyle(
            fontSize: 25, // Increased font size
            fontWeight: FontWeight.bold, // Optional: for better visibility
            color: Colors.black, // Optional: if needed
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: isCartEmpty
          ? _buildEmptyCart() // Show empty state if no items
          : SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 0,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. List of Selected Items (Use ListView.builder for all items)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.selectedItems.length,
                    itemBuilder: (context, index) {
                      return _buildCartItem(widget.selectedItems[index]);
                    },
                  ),

                  // 2. Add More Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context); // Go back to the menu
                        },
                        icon: Icon(Icons.add, color: primaryPurple),
                        label: Text(
                          "Add More",
                          style: TextStyle(
                            color: primaryPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: BorderSide(color: primaryPurple),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Divider(height: 1, color: Color(0xFFE0E0E0)),
                  const SizedBox(height: 20),

                  // 3. Discover Similar Meals Section
                  const Text(
                    "Discover Similar Meals",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 195,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.similarMeals.length,
                      itemBuilder: (context, index) {
                        return _buildSimilarMealCard(
                          widget.similarMeals[index],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Divider(height: 1, color: Color(0xFFE0E0E0)),
                  const SizedBox(height: 20),

                  // 4. Invoice Section
                  const Text(
                    "Invoice",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Item breakdown
                        ...widget.selectedItems.map((item) {
                          final itemPrice = _parsePrice(
                            item['price'].toString(),
                          );
                          final quantity = item['quantity'] as int;
                          final totalItemPrice = itemPrice * quantity;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${item['dishName']} x $quantity",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "₹ ${totalItemPrice.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        const Divider(height: 30, thickness: 1),

                        // Total Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "₹ ${widget.totalPrice.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // Small total detail line (matching screenshot style)
                        const SizedBox(height: 4),
                        const Text(
                          "(incl. fees and tax)",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),

      // 3. Conditional Bottom Sheet
      bottomSheet: isCartEmpty
          ? null // Hide bottom sheet if cart is empty
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Confirm Payment & Address",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
    );
  }
}
