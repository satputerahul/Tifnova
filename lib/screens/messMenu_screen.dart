import 'package:flutter/material.dart';
import 'package:Tifnova/screens/addCart.dart';

class MessMenuScreen extends StatefulWidget {
  final List<Map<String, String>> mess;
  final List<Map<String, String>> allMesses;

  const MessMenuScreen({
    super.key,
    required this.mess,
    required this.allMesses,
  });

  @override
  State<MessMenuScreen> createState() => _MessMenuScreenState();
}

class _MessMenuScreenState extends State<MessMenuScreen> {
  // We no longer track totalQuantity as a sum, 
  // but we will calculate the number of distinct items.
  int _distinctItemCount = 0; 
  double totalPrice = 0.0;

  List<Map<String, dynamic>> menuList = [
    {
      "image": "assets/images/thali.png",
      "dishName": "Full Tiffin",
      "price": "₹120",
      "rating": 4.8,
      "isPerPiece": false,
      "quantity": 0,
    },
    {
      "image": "assets/images/bhindi.png",
      "dishName": "Bhindi Fry",
      "price": "₹40",
      "rating": 4.2,
      "isPerPiece": false,
      "quantity": 0,
    },
    {
      "image": "assets/images/dum_aloo.png",
      "dishName": "Dum Aloo",
      "price": "₹40",
      "rating": 4.3,
      "isPerPiece": false,
      "quantity": 0,
    },
    {
      "image": "assets/images/rice.png",
      "dishName": "Jeera Rice",
      "price": "₹30",
      "rating": 4.6,
      "isPerPiece": false,
      "quantity": 0,
    },
    {
      "image": "assets/images/dal.png",
      "dishName": "Dal",
      "price": "₹30",
      "rating": 4.5,
      "isPerPiece": false,
      "quantity": 0,
    },
    {
      "image": "assets/images/chapati.png",
      "dishName": "Chapati",
      "price": "₹7",
      "rating": 4.7,
      "isPerPiece": true,
      "quantity": 0,
    },
    {
      "image": "assets/images/methi.jpg",
      "dishName": "Methi Bhaji",
      "price": "₹40",
      "rating": 4.5,
      "isPerPiece": false,
      "quantity": 0,
    },
    {
      "image": "assets/images/tawaPaneer.png",
      "dishName": "Tawa Paneer",
      "price": "₹150",
      "rating": 4.3,
      "isPerPiece": false,
      "quantity": 0,
    },
    {
      "image": "assets/images/kothambirWadi.jpeg",
      "dishName": "Kothambir Vadi",
      "price": "₹70",
      "rating": 4.9,
      "isPerPiece": false,
      "quantity": 0,
    },
    {
      "image": "assets/images/gulabJamun.jpeg",
      "dishName": "Gulab Jamun",
      "price": "₹50",
      "rating": 4.5,
      "isPerPiece": false,
      "quantity": 0,
    },
  ];

  double _parsePrice(String priceString) {
    String numericPrice = priceString.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(numericPrice) ?? 0.0;
  }

  // New function to calculate total price and distinct item count
  void _recalculateCart() {
    double newTotalPrice = 0.0;
    int newDistinctItemCount = 0;

    for (var item in menuList) {
      final quantity = item['quantity'] as int;
      if (quantity > 0) {
        newDistinctItemCount++;
        final itemPrice = _parsePrice(item['price'] as String);
        newTotalPrice += itemPrice * quantity;
      }
    }

    setState(() {
      totalPrice = newTotalPrice;
      _distinctItemCount = newDistinctItemCount;
    });
  }

  void _updateCart(int index, bool isIncrement) {
    setState(() {
      final item = menuList[index];
      int currentQuantity = item['quantity'] as int;

      // 1. Update the item's quantity locally
      if (isIncrement) {
        item['quantity'] = currentQuantity + 1;
      } else if (currentQuantity > 0) {
        item['quantity'] = currentQuantity - 1;
      }

      // 2. Recalculate the entire cart summary
      _recalculateCart();
    });
  }

  Widget _buildCartButton() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: () {
          List<Map<String, dynamic>> selectedItems = menuList
              .where((item) => item['quantity'] > 0)
              .toList();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddToCart(
                selectedItems: selectedItems,
                totalPrice: totalPrice,
                // ✅ PASS THE LIST RECEIVED BY THIS SCREEN
                similarMeals: widget.allMesses,
              ),
            ),
          );
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF870474),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      // Use the distinct item count (1, 2, 3...)
                      '$_distinctItemCount', 
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ),
              const Text(
                'View your cart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(
                  '₹ ${totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
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
          icon: Image.asset('assets/icons/back.png', width: 24, height: 24),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/icons/filter.png', width: 24, height: 24),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
        elevation: 0,
      ),
      // Use the distinct item count to decide visibility
      bottomNavigationBar: _distinctItemCount > 0 ? _buildCartButton() : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/thaliSadananad.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '4.7',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Sadanand Uphargruha',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pure Veg',
                    style: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const Text(
              "Today's Menu",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
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

// MENU ITEM CARD (Updated quantity display logic for better contrast)
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

  @override
  Widget build(BuildContext context) {
    int currentQuantity = item['quantity'] as int;
    final primaryPurple = const Color(0xFF870474);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                item["image"],
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["dishName"],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item["price"],
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${item["rating"]}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: currentQuantity > 0
                            ? () => onQuantityChanged(index, false)
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Icon(
                            Icons.remove,
                            size: 16,
                            // Change color based on availability
                            color: currentQuantity > 0 ? primaryPurple : Colors.grey.shade400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Text(
                          '$currentQuantity',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => onQuantityChanged(index, true),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryPurple,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 16,
                            color: Colors.white,
                          ),
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