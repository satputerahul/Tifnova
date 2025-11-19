import 'package:flutter/material.dart';
import 'package:Tifnova/screens/addCart.dart';
import 'package:Tifnova/l10n/app_localizations.dart';

class MessMenuScreen extends StatefulWidget {
  final List<Map<String, String>> mess;
  final List<Map<String, String>> allMesses;

  const MessMenuScreen({
    super.key,
    this.mess = const [],
    required this.allMesses,
  });

  @override
  State<MessMenuScreen> createState() => _MessMenuScreenState();
}

class _MessMenuScreenState extends State<MessMenuScreen> {
  int _distinctItemCount = 0;
  double totalPrice = 0.0;

  List<Map<String, dynamic>> menuList = [];

  List<Map<String, dynamic>> getLocalizedMenu(AppLocalizations l10n) {
    return [
      {
        "image": "assets/images/thali.png",
        "dishName": l10n.fullTiffin,
        "price": "₹120",
        "rating": 4.8,
        "isPerPiece": false,
        "quantity": 0,
      },
      {
        "image": "assets/images/bhindi.png",
        "dishName": l10n.bhindiFry,
        "price": "₹40",
        "rating": 4.2,
        "isPerPiece": false,
        "quantity": 0,
      },
      {
        "image": "assets/images/dum_aloo.png",
        "dishName": l10n.dumAloo,
        "price": "₹40",
        "rating": 4.3,
        "isPerPiece": false,
        "quantity": 0,
      },
      {
        "image": "assets/images/rice.png",
        "dishName": l10n.jeeraRice,
        "price": "₹30",
        "rating": 4.6,
        "isPerPiece": false,
        "quantity": 0,
      },
      {
        "image": "assets/images/dal.png",
        "dishName": l10n.dal,
        "price": "₹30",
        "rating": 4.5,
        "isPerPiece": false,
        "quantity": 0,
      },
      {
        "image": "assets/images/chapati.png",
        "dishName": l10n.chapati,
        "price": "₹7",
        "rating": 4.7,
        "isPerPiece": true,
        "quantity": 0,
      },
      {
        "image": "assets/images/methi.jpg",
        "dishName": l10n.methiBhaji,
        "price": "₹40",
        "rating": 4.5,
        "isPerPiece": false,
        "quantity": 0,
      },
      {
        "image": "assets/images/tawaPaneer.png",
        "dishName": l10n.tawaPaneer,
        "price": "₹150",
        "rating": 4.3,
        "isPerPiece": false,
        "quantity": 0,
      },
      {
        "image": "assets/images/kothambirWadi.jpeg",
        "dishName": l10n.kothambirVadi,
        "price": "₹70",
        "rating": 4.9,
        "isPerPiece": false,
        "quantity": 0,
      },
      {
        "image": "assets/images/gulabJamun.jpeg",
        "dishName": l10n.gulabJamun,
        "price": "₹50",
        "rating": 4.5,
        "isPerPiece": false,
        "quantity": 0,
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        menuList = getLocalizedMenu(AppLocalizations.of(context)!);
      });
    });
  }

  double _parsePrice(String priceString) {
    return double.tryParse(
          priceString.replaceAll(RegExp(r'[^\d.]'), ''),
        ) ??
        0.0;
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
      _distinctItemCount = count;
      totalPrice = newTotal;
    });
  }

  void _updateCart(int index, bool isIncrement) {
    int qty = menuList[index]['quantity'];

    setState(() {
      if (isIncrement) {
        menuList[index]['quantity'] = qty + 1;
      } else if (qty > 0) {
        menuList[index]['quantity'] = qty - 1;
      }
      _recalculateCart();
    });
  }

  Widget _buildCartButton(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: () async {
          final selectedItems =
              menuList.where((e) => e['quantity'] > 0).toList();
          print("MENU LIST BEFORE OPENING CART: $menuList");

          final updatedCart = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddToCart(
                selectedItems: selectedItems,
                totalPrice: totalPrice,
                similarMeals: widget.allMesses,
              ),
            ),
          );

          if (updatedCart is List) {
            setState(() {
              // Step 1: Reset all quantities to 0
              for (var item in menuList) {
                item['quantity'] = 0;
              }

              // Step 2: Apply updated cart quantities
              for (var cartItem in updatedCart) {
                // Safe matching without null
                var match = menuList.firstWhere(
                  (e) => e['dishName'] == cartItem['dishName'],
                  orElse: () => <String, dynamic>{}, // SAFE empty map
                );

                if (match.isNotEmpty) {
                  match['quantity'] = cartItem['quantity'];
                }
              }

              // Recalculate totals
              _recalculateCart();
            });
          }
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF870474),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      '$_distinctItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                l10n.viewYourCart,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  "₹ ${totalPrice.toStringAsFixed(0)}",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 NEW: Similar Meals Card Builder
  Widget _buildSimilarMealCard(
      Map<String, String> mess, AppLocalizations l10n) {
    // Current mess ला skip करतो
    final currentMessName =
        widget.mess.isNotEmpty ? widget.mess.first['name'] : '';
    if (mess['name'] == currentMessName) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MessMenuScreen(
              mess: [mess],
              allMesses: widget.allMesses,
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with gradient overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(14)),
                  child: Image.asset(
                    mess['image']!,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Rating badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          mess['rating']!,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    mess['name']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Description
                  Text(
                    mess['description']!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  // Time & Delivery info
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        mess['time']!,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.delivery_dining,
                        size: 16,
                        color: mess['delivery'] == "Free"
                            ? Colors.green
                            : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        mess['delivery']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: mess['delivery'] == "Free"
                              ? Colors.green
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentMess = widget.mess.isNotEmpty ? widget.mess.first : null;

    // Filter similar messes (exclude current one)
    final similarMesses = widget.allMesses
        .where((mess) => mess['name'] != currentMess?['name'])
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: Image.asset("assets/icons/back.png", width: 24),
            onPressed: () {
              Navigator.pop(context, menuList);
            }),
      ),
      bottomNavigationBar:
          _distinctItemCount > 0 ? _buildCartButton(l10n) : null,
      body: menuList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- HEADER ----------
                  if (currentMess != null) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            currentMess['image'] ?? '',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                currentMess['name'] ?? '',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    currentMess['rating'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      height: 1.0,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n.pureVeg,
                                    style: TextStyle(
                                      color: Colors.green.shade600,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      height: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                currentMess['description'] ?? '',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  height: 1.1,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ---------- TODAY'S MENU ----------
                  Text(
                    l10n.todaysMenu,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  ListView.builder(
                    itemCount: menuList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, i) {
                      return MenuItemCard(
                        item: menuList[i],
                        index: i,
                        onQuantityChanged: _updateCart,
                      );
                    },
                  ),

                  // ---------- 🔥 DISCOVER SIMILAR MEALS SECTION ----------
                  if (similarMesses.isNotEmpty) ...[
                    const SizedBox(height: 24),

                    // Section Header
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.discoverSimilarMeals,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: const Color(0xFF870474),
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Explore other popular tiffin services",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Horizontal Scrollable List
                    SizedBox(
                      height: 240,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: similarMesses.length,
                        itemBuilder: (_, i) =>
                            _buildSimilarMealCard(similarMesses[i], l10n),
                      ),
                    ),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }
}

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
    int qty = item["quantity"];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
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
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item["price"],
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text("${item["rating"]}"),
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
                        onTap: qty > 0
                            ? () => onQuantityChanged(index, false)
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Icon(
                            Icons.remove,
                            size: 16,
                            color:
                                qty > 0 ? const Color(0xFF870474) : Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          "$qty",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      InkWell(
                        onTap: () => onQuantityChanged(index, true),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Color(0xFF870474),
                            shape: BoxShape.circle,
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
