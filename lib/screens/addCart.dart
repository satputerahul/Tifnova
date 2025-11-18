import 'package:Tifnova/screens/address_screen.dart';
import 'package:flutter/material.dart';
import 'package:Tifnova/l10n/app_localizations.dart';
import 'package:Tifnova/screens/messMenu_screen.dart'; // ✅ correct path

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

  late List<Map<String, dynamic>> cartItems;
  double cartTotal = 0.0;

  @override
  void initState() {
    super.initState();
    cartItems =
        widget.selectedItems.map((e) => Map<String, dynamic>.from(e)).toList();
    cartTotal = widget.totalPrice;
  }

  double _parsePrice(String priceString) {
    String numericPrice = priceString.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(numericPrice) ?? 0;
  }

  void _recalculateTotal() {
    double total = 0;
    for (var item in cartItems) {
      total += _parsePrice(item['price']) * item['quantity'];
    }
    setState(() => cartTotal = total);
  }

  void increaseQty(int index) {
    setState(() {
      cartItems[index]['quantity']++;
    });
    _recalculateTotal();
  }

  void decreaseQty(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
      } else {
        cartItems.removeAt(index);
      }
    });
    _recalculateTotal();
  }

  void deleteItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
    _recalculateTotal();
  }

  Widget _buildEmptyCart(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icons/empty_cart.png", height: 150, width: 150),
            const SizedBox(height: 20),
            Text(
              l10n.yourCartIsEmpty,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.cartEmptySubtitle,
              style: const TextStyle(fontSize: 15, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                l10n.browseMeals,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(
      Map<String, dynamic> item, int index, AppLocalizations l10n) {
    final price = _parsePrice(item["price"]);
    final qty = item["quantity"];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
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
              children: [
                Text(
                  item["dishName"],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text("₹ ${price.toStringAsFixed(0)}",
                    style: const TextStyle(color: Colors.grey)),
                Text("${l10n.qty}: $qty",
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => decreaseQty(index),
                  child: const Text("-", style: TextStyle(fontSize: 16)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "$qty",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                InkWell(
                  onTap: () => increaseQty(index),
                  child: Container(
                    padding: const EdgeInsets.all(3),
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
            onTap: () => deleteItem(index),
            child: const Icon(Icons.delete_outline, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarMealCard(
      Map<String, String> mess, AppLocalizations l10n) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MessMenuScreen(
              mess: [mess],
              allMesses: widget.similarMeals,
            ),
          ),
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                mess['image']!,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          mess['name']!,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      Text(
                        mess['rating']!,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    mess['description']!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        mess['time']!,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Text(" • "),
                      const Icon(Icons.delivery_dining,
                          size: 12, color: Colors.grey),
                      const SizedBox(width: 3),
                      Text(
                        mess['delivery']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: mess['delivery'] == "Free"
                              ? Colors.green
                              : Colors.grey,
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
    final bool isEmpty = cartItems.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset("assets/icons/back.png", width: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.cart,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: isEmpty
          ? _buildEmptyCart(l10n)
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // cart items
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartItems.length,
                    itemBuilder: (_, i) =>
                        _buildCartItem(cartItems[i], i, l10n),
                  ),
                  const SizedBox(height: 20),

                  // add more
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.add, color: primaryPurple),
                      label: Text(
                        l10n.addMore,
                        style: TextStyle(
                            color: primaryPurple, fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryPurple),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // similar meals
                  Text(
                    l10n.discoverSimilarMeals,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200, // overflow टाळण्यासाठी थोडं जास्त height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.similarMeals.length,
                      itemBuilder: (_, i) =>
                          _buildSimilarMealCard(widget.similarMeals[i], l10n),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // invoice
                  Text(
                    l10n.invoice,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        ...cartItems.map((item) {
                          final price = _parsePrice(item['price']);
                          final qty = item['quantity'];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${item['dishName']} x $qty",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "₹ ${(price * qty).toStringAsFixed(0)}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }),
                        const Divider(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.total,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₹ ${cartTotal.toStringAsFixed(0)}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.inclFeesTax,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
      bottomSheet: isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AddressListScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    l10n.confirmPaymentAddress,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
