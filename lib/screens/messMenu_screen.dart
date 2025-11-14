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

  double _parsePrice(String p) {
    return double.tryParse(p.replaceAll(RegExp(r'[^\d]'), '')) ?? 0.0;
  }

  void _recalculateCart() {
    double newTotal = 0.0;
    int count = 0;

    for (var item in menuList) {
      int qty = item['quantity'];
      if (qty > 0) {
        count++;
        newTotal += _parsePrice(item['price']) * qty;
      }
    }

    setState(() {
      totalPrice = newTotal;
      _distinctItemCount = count;
    });
  }

  void _updateCart(int index, bool increment) {
    final item = menuList[index];
    int q = item['quantity'];

    if (increment) {
      item['quantity'] = q + 1;
    } else if (q > 0) {
      item['quantity'] = q - 1;
    }

    _recalculateCart();
  }

  // ------------------------------------
  //     CART BUTTON  (fixed version)
  // ------------------------------------
  Widget _buildCartButton() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: () async {
          // only items with quantity > 0
          List<Map<String, dynamic>> selectedItems =
              menuList.where((e) => e['quantity'] > 0).toList();

          final updatedCart = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddToCart(
                selectedItems: selectedItems,
                totalPrice: totalPrice,
                similarMeals: widget.allMesses,
              ),
            ),
          );

          // 🔥 VERY IMPORTANT — pass updated cart back to Home
          if (updatedCart is List<Map<String, dynamic>>) {
            Navigator.pop(context, updatedCart);
          }
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
                padding: const EdgeInsets.only(left: 10),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.transparent,
                  child: Text(
                    '$_distinctItemCount',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
              const Text(
                'View your cart',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  "₹ ${totalPrice.toStringAsFixed(0)}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------
  //   MAIN UI
  // -------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/icons/back.png', width: 25),
          onPressed: () {
            // back करताना selected cart परत पाठवणे
            final selectedItems =
                menuList.where((e) => e['quantity'] > 0).toList();

            Navigator.pop(context, selectedItems);
          },
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/icons/filter.png', width: 22),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),

      bottomNavigationBar:
          _distinctItemCount > 0 ? _buildCartButton() : null,

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image:
                            AssetImage('assets/images/thaliSadananad.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.star,
                          size: 16, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(
                        "4.7",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text("Sadanand Uphargruha",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("Pure Veg",
                      style: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Today's Menu",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 12),

            // MENU LIST
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
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------
//                             MENU CARD
// --------------------------------------------------------------------

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
    int qty = item['quantity'];
    final Color purple = const Color(0xFF870474);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
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
                  style:
                      const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  item["price"],
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.star,
                      size: 14, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text("${item['rating']}",
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(18)),
                child: Row(
                  children: [
                    InkWell(
                      onTap: qty > 0
                          ? () => onQuantityChanged(index, false)
                          : null,
                      child: Icon(Icons.remove,
                          size: 18,
                          color: qty > 0
                              ? purple
                              : Colors.grey.shade400),
                    ),
                    const SizedBox(width: 8),
                    Text("$qty",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => onQuantityChanged(index, true),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: purple, shape: BoxShape.circle),
                        child: const Icon(Icons.add,
                            size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
