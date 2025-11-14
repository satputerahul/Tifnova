import 'package:Tifnova/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:Tifnova/screens/like_menu.dart';
import 'package:Tifnova/screens/login_screen.dart';
import 'package:Tifnova/screens/messMenu_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/cupertino.dart';
import 'addCart.dart';
import 'dart:io';

class MessListScreen extends StatefulWidget {
  const MessListScreen({
    super.key,
    required List<Map<String, String>> mess,
    required List<Map<String, String>> allMesses,
  });

  @override
  State<MessListScreen> createState() => _MessListScreenState();
}

class _MessListScreenState extends State<MessListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _cartItemCount = 0;
  final double _cartTotalPrice = 120.0;
  String _currentAddress = 'Fetching location...';
  String _currentLocality = 'Sadanand Colony';
  List<Map<String, dynamic>> cartItems = [];

  List<Map<String, String>> messes = [
    {
      "name": "Patil Mess",
      "description": "Daily changing traditional Maharashtrian thali.",
      "rating": "4.7",
      "image": "assets/images/PatilKhanawal.png",
      "time": "20 min",
      "delivery": "Free",
    },
    {
      "name": "Sadanand Upharagruha",
      "description": "Authentic vegetarian snacks and meals.",
      "rating": "4.7",
      "image": "assets/images/sadanandUphargruha.png",
      "time": "20 min",
      "delivery": "Free",
    },
    {
      "name": "Annapurna Mess",
      "description": "Daily home cooked all-you-can-eat.",
      "rating": "4.3",
      "image": "assets/images/AnnapurnaMess.jpeg",
      "time": "30 min",
      "delivery": "₹20",
    },
    {
      "name": "Amruta Mess",
      "description": "Coconut-rich South Indian meals.",
      "rating": "4.6",
      "image": "assets/images/AmrutaMess.jpeg",
      "time": "25 min",
      "delivery": "Free",
    },
    {
      "name": "Swadistam",
      "description": "Modern North Indian tiffin service.",
      "rating": "4.6",
      "image": "assets/images/Swadistam.png",
      "time": "25 min",
      "delivery": "Free",
    },
  ];

  List<Map<String, String>> categories = [
    {"name": "Thali", "image": "assets/images/thali.png"},
    {"name": "Vegetable", "image": "assets/images/vegetable.png"},
    {"name": "Chicken", "image": "assets/images/chicken.png"},
    {"name": "Snacks", "image": "assets/images/snaks.png"},
    {"name": "Paratha", "image": "assets/images/paratha.jpeg"},
    {"name": "South Indian", "image": "assets/images/southIndian.jpeg"},
  ];

  List<Map<String, String>> favoriteList = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentAddress = 'Location services are disabled.';
      });
      return;
      print("Current Address: $_currentAddress");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentAddress = 'Location permissions are denied';
        });
        print("Current Address: $_currentAddress");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentAddress = 'Location permissions are permanently denied.';
      });
      print("Current Address: $_currentAddress");

      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      
    } catch (e) {
      setState(() {
        _currentAddress = 'Could not fetch location: $e';
      });
    }
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  Widget _customAssetImage(
    String assetPath, {
    Color? color,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
  }) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      color: color,
      fit: fit,
      alignment: alignment,
    );
  }

  Widget _buildCategoryItem(Map<String, String> category) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipOval(
            child: _customAssetImage(
              category['image']!,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          category['name']!,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildKitchenCard(Map<String, String> mess) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MessMenuScreen(mess: [mess], allMesses: messes),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  child: _customAssetImage(
                    mess['image']!,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (favoriteList.contains(mess)) {
                        favoriteList.remove(mess);
                        Fluttertoast.showToast(
                          msg: "${mess['name']} removed from Likes",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                        );
                      } else {
                        favoriteList.add(mess);
                        Fluttertoast.showToast(
                          msg: "${mess['name']} added to Likes",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                        );
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      favoriteList.contains(mess)
                          ? 'assets/icons/unlike.png'
                          : 'assets/icons/like.png',
                      width: 28,
                      height: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      mess['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        _customAssetImage(
                          'assets/icons/star.png',
                          color: const Color(0xFFFFC107),
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          mess['rating']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  mess['description']!,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      color: Colors.grey,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      mess['time']!,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.delivery_dining_outlined,
                      color: Colors.grey,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      mess['delivery']!,
                      style: TextStyle(
                        fontSize: 13,
                        color: mess['delivery'] == 'Free'
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
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Column(
        children: [
          Container(
            color: const Color(0xFF870474),
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
            width: double.infinity,
            child: Row(
              children: [
                Image.asset(
                  'assets/images/tifnova.png',
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.25,
                ),
                const SizedBox(width: 3),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Vidhi Gundekar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.home_outlined,
                    color: Colors.black87,
                  ),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.help_outline,
                    color: Colors.black87,
                  ),
                  title: const Text('Help'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.black87,
                  ),
                  title: const Text('Your Orders'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person_outline,
                    color: Colors.black87,
                  ),
                  title: const Text('Your Account'),
                  onTap: () {
                    // Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.share_outlined,
                    color: Colors.black87,
                  ),
                  title: const Text('Share App'),
                  onTap: () async {
                    Navigator.pop(context);

                    await Future.delayed(const Duration(milliseconds: 300));

                    final result = await Share.share(
                      'Hey! Check out this awesome app!'
                    );

                    print('Share result: $result');
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              children: [
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                      msg: "Logging out...",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black54,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  @override
Widget build(BuildContext context) {
  final bool isCartBadgeVisible = _cartItemCount > 0;
  return Scaffold(
    key: _scaffoldKey,
    drawer: _buildDrawer(),
    body: Platform.isIOS
        ? CustomScrollView(
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: _handleRefresh,
                builder: (
                  BuildContext context,
                  RefreshIndicatorMode refreshState,
                  double pulledExtent,
                  double refreshTriggerPullDistance,
                  double refreshIndicatorExtent,
                ) {
                  return const CupertinoActivityIndicator(
                    color: Color(0xFF870474),
                  );
                },
              ),
              SliverToBoxAdapter(
                child: _buildContent(),
              ),
            ],
          )
        : RefreshIndicator(
            onRefresh: _handleRefresh,
            color: const Color(0xFF870474),
            child: _buildContent(),
          ),
  );
}

Widget _buildContent() {
  return SingleChildScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(
                            'assets/icons/user.png',
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          
                        },
                        child: _customAssetImage(
                          'assets/icons/location.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentLocality,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _currentAddress,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Stack(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: _customAssetImage(
                              'assets/icons/like.png',
                              width: 35,
                              height: 35,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LikeMenu(
                                    favoriteList: favoriteList,
                                    allMesses: messes,
                                  ),
                                ),
                              );
                            },
                          ),
                          if (favoriteList.isNotEmpty)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF870474),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  '${favoriteList.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Stack(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: _customAssetImage(
                              'assets/icons/cart.png',
                              width: 35,
                              height: 35,
                            ),
                            onPressed: () async {
                              final updatedCart = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddToCart(
                                    selectedItems: cartItems,
                                    totalPrice: _cartTotalPrice,
                                    similarMeals: messes,
                                  ),
                                ),
                              );
                              if (updatedCart is List) {
                                setState(() {
                                  cartItems =
                                      List<Map<String, dynamic>>.from(updatedCart);
                                  _cartItemCount = cartItems.length;
                                });
                              }
                            },
                          ),
                          if (_cartItemCount > 0)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF870474),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  '$_cartItemCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      right: 8.0,
                    ),
                    child: _customAssetImage(
                      'assets/icons/search.png',
                      color: Colors.grey,
                      width: 20,
                      height: 20,
                    ),
                  ),
                  hintText: 'Search menu, kitchens or etc',
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(
                      right: 12.0,
                      left: 8.0,
                    ),
                    child: _customAssetImage(
                      'assets/icons/filter.png',
                      color: Colors.grey,
                      width: 20,
                      height: 20,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF870474), Color(0xFF421B86)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  left: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Tifnova at',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'your service!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: -30,
                  top: (130 - 160) / 2,
                  child: SizedBox(
                    width: 195,
                    height: 160,
                    child: Center(
                      child: Image.asset(
                        'assets/images/delivery_boy.png',
                        width: 155,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 12.0),
          child: Text(
            "What's on your mind?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            height: 105,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.25,
              ),
              itemBuilder: (context, index) {
                return _buildCategoryItem(categories[index]);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 12.0),
          child: Text(
            "Explore Kitchens",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: messes.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessMenuScreen(
                        mess: [messes[index]],
                        allMesses: messes,
                      ),
                    ),
                  );
                },
                child: _buildKitchenCard(messes[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                print("Explore by Dishes tapped!");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF870474),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Explore by Dishes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    ),
  );
}

}
