import 'package:flutter/material.dart';

// --- MAIN SCREEN CLASS ---
class MessMenuScreen extends StatefulWidget {
  final List<Map<String, String>> mess;

  const MessMenuScreen({super.key, required this.mess});

  @override
  State<MessMenuScreen> createState() => _MessMenuScreenState();
}

class _MessMenuScreenState extends State<MessMenuScreen> {

  int totalQuantity = 0;
  double totalPrice = 0.0;
  
  // Data structure (kept the same)
  List<Map<String, dynamic>> menuList = [
    {
      "image": "assets/images/thali.png", "dishName": "Full Tiffin", 
      "price": "₹120", "rating": 4.8, "isPerPiece": false, "quantity": 0,
    },
    {
      "image": "assets/images/bhindi.png", "dishName": "Bhindi Fry", 
      "price": "₹40", "rating": 4.2, "isPerPiece": false, "quantity": 0,
    },
    {
      "image": "assets/images/dum_aloo.png", "dishName": "Dum Aloo", 
      "price": "₹40", "rating": 4.3, "isPerPiece": false, "quantity": 0,
    },
    {
      "image": "assets/images/rice.png", "dishName": "Jeera Rice", 
      "price": "₹30", "rating": 4.6, "isPerPiece": false, "quantity": 0,
    },
    {
      "image": "assets/images/dal.png", "dishName": "Dal", 
      "price": "₹30", "rating": 4.5, "isPerPiece": false, "quantity": 0,
    },
    {
      "image": "assets/images/chapati.png", "dishName": "Chapati", 
      "price": "₹7", "rating": 4.7, "isPerPiece": true, "quantity": 0,
    },
    {
      "image": "assets/images/methi.jpg", "dishName": "Methi Bhaji", 
      "price": "₹40", "rating": 4.5, "isPerPiece": false, "quantity": 0,
    },
    {
      "image": "assets/images/tawaPaneer.png", "dishName": "Tawa Paneer", 
      "price": "₹150", "rating": 4.3, "isPerPiece": false, "quantity": 0,
    },
    {
      "image": "assets/images/kothambirWadi.jpeg", "dishName": "Kothambir Vadi", 
      "price": "₹70", "rating": 4.9, "isPerPiece": false, "quantity": 0,
    },
    {
      "image": "assets/images/gulabJamun.jpeg", "dishName": "Gulab Jamun", 
      "price": "₹50", "rating": 4.5, "isPerPiece": false, "quantity": 0,
    },
  ];  

  // Helper function to safely parse the price string into a double (Fixes the error)
  double _parsePrice(String priceString) {
    String numericPrice = priceString.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(numericPrice) ?? 0.0;
  }

  // METHOD TO UPDATE CART STATE
  void _updateCart(int index, bool isIncrement) {
    setState(() {
      final item = menuList[index];
      double itemPrice = _parsePrice(item['price'] as String);
      int currentQuantity = item['quantity'] as int;

      if (isIncrement) {
        item['quantity'] = currentQuantity + 1; 
        totalQuantity++;
        totalPrice += itemPrice;
      } else if (currentQuantity > 0) {
        item['quantity'] = currentQuantity - 1;
        totalQuantity--;
        totalPrice -= itemPrice;
      }
    });
  }

  // WIDGET FOR THE FLOATING CART BUTTON (SIZES REDUCED)
  Widget _buildCartButton() {
    return Padding(
      padding: const EdgeInsets.all(12.0), // Reduced padding
      child: Container(
        height: 50, // Reduced height
        decoration: BoxDecoration(
          color: const Color(0xFF870474), // Purple color
          borderRadius: BorderRadius.circular(10.0), // Reduced radius
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                width: 25, // Reduced size
                height: 25, // Reduced size
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Center(
                  child: Text(
                    '$totalQuantity',
                    style: const TextStyle(color: Colors.white, fontSize: 14), // Reduced font size
                  ),
                ),
              ),
            ),
            const Text(
              'View your cart',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500), // Reduced font size
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Text(
                '₹ ${totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500), // Reduced font size
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Image.asset('assets/icons/back.png', width: 24, height: 24), // Reduced icon size
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/icons/filter.png', width: 24, height: 24), // Reduced icon size
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
        elevation: 0,
      ),
      
      bottomNavigationBar: totalQuantity > 0 ? _buildCartButton() : null,
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Mess Header Section (SIZES REDUCED) ---
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120, height: 120, // Reduced image size (was 150x150)
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12), // Reduced radius
                      image: const DecorationImage(
                        image: AssetImage('assets/images/thaliSadananad.png'), 
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8), // Reduced spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16), // Reduced icon size
                      const SizedBox(width: 4),
                      const Text('4.7', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // Reduced font size
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('Sadanand Uphargruha', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // Reduced font size
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1), // Reduced padding
                    decoration: BoxDecoration(color: Colors.green.shade500, borderRadius: BorderRadius.circular(5)),
                    child: const Text('Pure Veg', style: TextStyle(color: Colors.white, fontSize: 14)), // Reduced font size
                  ),
                  const SizedBox(height: 16), // Reduced spacing
                ],
              ),
            ),
            
            // --- Today's Menu Title (FONT REDUCED) ---
            const Text("Today's Menu", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Reduced font size
            const SizedBox(height: 8), // Reduced spacing

            // --- Menu List ---
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), 
              itemCount: menuList.length,
              itemBuilder: (context, index) {
                return MenuItemCard( 
                  item: menuList[index],
                  index: index,
                  onQuantityChanged: _updateCart,
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// --- Custom Widget for a Single Menu Item (SIZES REDUCED) ---
class MenuItemCard extends StatelessWidget { 
  final Map<String, dynamic> item;
  final int index;
  final Function(int, bool) onQuantityChanged; 

  const MenuItemCard({
    super.key, 
    required this.item,
    required this.index,
    required this.onQuantityChanged,
  });

  static const Color borderColor = Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    int currentQuantity = item['quantity'] as int;

    return Padding(
      // Outer vertical padding is now part of the card's spacing
      padding: const EdgeInsets.only(bottom: 10.0), // Reduced spacing
      
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(10.0), 
          border: Border.all(
            color: borderColor, 
            width: 1.0, 
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 2), 
            ),
          ],
        ),
        // Inner padding for the content inside the card
        padding: const EdgeInsets.all(10.0), // Reduced inner padding

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            // Dish Image (Left)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                item["image"],
                width: 70, // Reduced image size (was 80)
                height: 70, // Reduced image size (was 80)
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            
            // Dish Details (Middle)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  // Dish Name (FONT REDUCED)
                  Text(item["dishName"], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)), // Reduced font size
                  const SizedBox(height: 2), // Reduced spacing
                  // Price (FONT REDUCED)
                  Row(
                    children: [
                      Text(
                        item["price"], 
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]), // Reduced font size
                      ),
                      if (item["isPerPiece"] ?? false) 
                        Text(
                          '/Piece',
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]), // Reduced font size
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Rating and Quantity Controls (Right)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Rating (FONT REDUCED)
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14), // Reduced icon size
                    const SizedBox(width: 4),
                    Text('${item["rating"]}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)), // Reduced font size
                  ],
                ),
                const SizedBox(height: 8),
                // Quantity Controls (SIZE REDUCED)
                Container(
                  // Reduced overall size by adjusting padding/internal spacing
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 1.0), 
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      // Minus Button
                      InkWell(
                        onTap: currentQuantity > 0 
                            ? () => onQuantityChanged(index, false) 
                            : null, 
                        child: Container(
                          padding: const EdgeInsets.all(3), // Reduced padding
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentQuantity > 0 ? Colors.grey.shade100 : Colors.transparent,
                          ),
                          child: Icon(Icons.remove, size: 16, color: currentQuantity > 0 ? Colors.grey[600] : Colors.grey[400]), // Reduced icon size
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0), // Reduced padding
                        child: Text('$currentQuantity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), // Reduced font size
                      ),
                      // Plus Button
                      InkWell(
                        onTap: () => onQuantityChanged(index, true), 
                        child: Container(
                          padding: const EdgeInsets.all(3), // Reduced padding
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF870474), 
                          ),
                          child: const Icon(Icons.add, size: 16, color: Colors.white), // Reduced icon size
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}