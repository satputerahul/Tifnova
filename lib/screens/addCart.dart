import 'package:flutter/material.dart';
import 'package:Tifnova/screens/address_screen.dart';
import 'package:Tifnova/l10n/app_localizations.dart';

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

class _AddToCartState extends State<AddToCart>
    with SingleTickerProviderStateMixin {
  final Color primaryPurple = const Color(0xFF870474);
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  late List<Map<String, dynamic>> cartItems;
  double cartTotal = 0.0;

  @override
  void initState() {
    super.initState();
    cartItems =
        widget.selectedItems.map((e) => Map<String, dynamic>.from(e)).toList();
    cartTotal = widget.totalPrice;
    print("SELECTED ITEMS PASSED TO ADD TO CART: ${widget.selectedItems}");

    // Animation setup
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item removed from cart'),
        duration: const Duration(seconds: 2),
        backgroundColor: primaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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
                elevation: 3,
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

    return Dismissible(
      key: Key('${item["dishName"]}_$index'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => deleteItem(index),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: 'cart_${item["dishName"]}_$index',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  item["image"],
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["dishName"],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₹ ${price.toStringAsFixed(0)}",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${l10n.qty}: $qty",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => decreaseQty(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.remove,
                        size: 18,
                        color: primaryPurple,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "$qty",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  InkWell(
                    onTap: () => increaseQty(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: primaryPurple,
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.add, size: 16, color: Colors.white),
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

  Widget _buildPromoSection(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryPurple.withOpacity(0.1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryPurple.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.local_offer, color: primaryPurple, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Apply Promo Code",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: primaryPurple,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Save more on your order",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: primaryPurple, size: 16),
        ],
      ),
    );
  }

  Widget _buildInvoiceSection(AppLocalizations l10n) {
    final subtotal = cartTotal;
    final deliveryFee = 20.0;
    final gst = subtotal * 0.05;
    final finalTotal = subtotal + deliveryFee + gst;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long, color: primaryPurple, size: 22),
              const SizedBox(width: 8),
              Text(
                l10n.invoice,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...cartItems.map((item) {
            final price = _parsePrice(item['price']);
            final qty = item['quantity'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${item['dishName']} × $qty",
                      style: const TextStyle(fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "₹ ${(price * qty).toStringAsFixed(0)}",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }),
          Divider(height: 24, thickness: 1, color: Colors.grey.shade300),
          _buildInvoiceRow("Subtotal", subtotal),
          const SizedBox(height: 6),
          _buildInvoiceRow("Delivery Fee", deliveryFee),
          const SizedBox(height: 6),
          _buildInvoiceRow("GST (5%)", gst),
          Divider(height: 24, thickness: 1.5, color: Colors.grey.shade400),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              Text(
                "₹ ${finalTotal.toStringAsFixed(0)}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.inclFeesTax,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        Text(
          "₹ ${amount.toStringAsFixed(0)}",
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool isEmpty = cartItems.isEmpty;
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, cartItems);
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                icon: Image.asset("assets/icons/back.png", width: 28),
                onPressed: () {
                  print("SENDING BACK DATA: $cartItems");
                  Navigator.pop(context, cartItems);
                }),
            title: Text(
              l10n.cart,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            actions: [
              if (!isEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_sweep, color: Colors.grey),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Clear Cart?"),
                        content: const Text(
                            "Are you sure you want to remove all items?"),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() => cartItems.clear());
                              _recalculateTotal();
                              Navigator.pop(context, cartItems);
                            },
                            child: Text("Clear",
                                style: TextStyle(color: primaryPurple)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
          body: isEmpty
              ? _buildEmptyCart(l10n)
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cart Items Count
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: primaryPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.shopping_bag,
                                  color: primaryPurple, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                "${cartItems.length} ${cartItems.length == 1 ? 'item' : 'items'} in cart",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: primaryPurple,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Cart Items
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartItems.length,
                          itemBuilder: (_, i) =>
                              _buildCartItem(cartItems[i], i, l10n),
                        ),
                        const SizedBox(height: 20),

                        // Add More Button
                        Center(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.add_circle_outline,
                                color: primaryPurple),
                            label: Text(
                              l10n.addMore,
                              style: TextStyle(
                                color: primaryPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              side:
                                  BorderSide(color: primaryPurple, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Promo Section
                        _buildPromoSection(l10n),
                        const SizedBox(height: 24),

                        // Invoice
                        _buildInvoiceSection(l10n),
                        const SizedBox(height: 140),
                      ],
                    ),
                  ),
                ),
          bottomSheet: isEmpty
              ? null
              : Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AddressListScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPurple,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_outline,
                                color: Colors.white),
                            const SizedBox(width: 10),
                            Text(
                              l10n.confirmPaymentAddress,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ));
  }
}
