import 'package:Tifnova/screens/login_screen.dart';
import 'package:Tifnova/screens/messMenu_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MessListScreen extends StatefulWidget {
  const MessListScreen({super.key});
  @override
  State<MessListScreen> createState() => _MessListScreenState();
}

class _MessListScreenState extends State<MessListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // --- Mock Data ---

  // Kitchens Data (used for the 'Explore Kitchens' section)
  List<Map<String, String>> messes = [
    {
      "name": "Patil Mess",
      "description":
          "Daily changing traditional Maharashtrian thali.", // Updated to be veg
      "rating": "4.7",
      "image": "assets/images/PatilKhanawal.png",
      "time": "20 min",
      "delivery": "Free",
    },
    {
      "name": "Sadanand Upharagruha",
      "description":
          "Authentic vegetarian snacks and meals.", // Already vegetarian
      "rating": "4.7",
      "image": "assets/images/sadanandUphargruha.png",
      "time": "20 min",
      "delivery": "Free",
    },
    {
      "name": "Annapurna Mess",
      "description":
          "Daily home cooked all-you-can-eat.", // Updated to be general veg
      "rating": "4.3",
      "image": "assets/images/AnnapurnaMess.jpeg",
      "time": "30 min",
      "delivery": "₹20",
    },
    {
      "name": "Amruta Mess",
      "description": "Coconut-rich South Indian meals.", // Already vegetarian
      "rating": "4.6",
      "image": "assets/images/AmrutaMess.jpeg",
      "time": "25 min",
      "delivery": "Free",
    },
    {
      "name": "Swadistam",
      "description":
          "Modern North Indian tiffin service.", // Already vegetarian
      "rating": "4.6",
      "image": "assets/images/Swadistam.png",
      "time": "25 min",
      "delivery": "Free",
    },
  ];

  // Categories Data (used for the 'What's on your mind?' section)
  List<Map<String, String>> categories = [
    {"name": "Thali", "image": "assets/images/thali.png"},
    {"name": "Vegetable", "image": "assets/images/vegetable.png"},
    {"name": "Chicken", "image": "assets/images/chicken.png"},
    {"name": "Snacks", "image": "assets/images/snaks.png"},
    {"name": "Paratha", "image": "assets/images/paratha.jpeg"},
    {"name": "South Indian", "image": "assets/images/southIndian.jpeg"},
  ];

  // --- Refresh Function ---

  Future<void> _handleRefresh() async {
    // Simulate a network delay or data fetching time
    await Future.delayed(const Duration(milliseconds: 1000));
    // In a real app, you would call setState() here to update your data:
    // setState(() { messes = fetchNewMesses(); });
  }

  // --- Helper Widgets ---

  // Helper widget to load custom Image assets
  Widget _customAssetImage(
    String assetPath, {
    Color? color,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    // *** 1. ADDED ALIGNMENT PARAMETER ***
    Alignment alignment = Alignment.center,
  }) {
    // NOTE: Ensure these asset paths exist in your pubspec.yaml and project structure.
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      color: color,
      fit: fit,
      // *** USE THE ALIGNMENT PARAMETER ***
      alignment: alignment,
    );
  }

  // Widget to build a single Category circle item
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
              fit: BoxFit.cover, // Ensures category image fills circle
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
          color: Colors.grey.withOpacity(0.1),
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
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: _customAssetImage(
                mess['image']!,
                height: 140, 
                width: double.infinity, 
                
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite_border,
                  color: Color(0xFF870474),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        // Text content starts here
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
                          color: const Color(
                            0xFFFFC107,
                          ), 
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

  // --- Drawer (Sidebar) ---
  Widget _buildDrawer() {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Column(
        children: [
          // Purple Header (Top Section)
          Container(
            color: const Color(0xFF870474),
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
            width: double.infinity,
            child: Row(
              children: [
                // Left side image (Mascot or logo)
                Image.asset(
                  'assets/images/tifnova.png', // Replace with your actual asset
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.25,
                ),
                const SizedBox(width: 3),
                // Greeting and username
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
          // Drawer menu items
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
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.share_outlined,
                    color: Colors.black87,
                  ),
                  title: const Text('Share App'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          // Logout button at bottom
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
                      backgroundColor:
                          Colors.black54, // Customizable background
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

  // --- Main Screen Build ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      // 1. Wrap the entire body in RefreshIndicator
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: const Color(0xFF870474), // Set refresh color to purple
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // Ensures refresh works even if content doesn't fill screen
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- Header Section (Profile, Location, Cart, Search) ---
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
                        // Left side: profile + location
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
                            _customAssetImage(
                              'assets/icons/location.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Sadanand Colony',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Dadar',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Right side: icons
                        Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: _customAssetImage(
                                'assets/icons/like.png',
                                width: 35,
                                height: 35,
                              ),
                              onPressed: () {},
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
                                  onPressed: () {},
                                ),
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
                                    child: const Text(
                                      '1',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
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
                    // Search Bar
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
              // --- Gradient Banner Section ---
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  height: 130, // Banner height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF870474), // Left color
                        Color(0xFF421B86), // Right color
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Left side - Text
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
                      // Right side - Illustration
                      Positioned(
                        right: -30,
                        top: (130 - 160) / 2,
                        child: SizedBox(
                          width: 195,
                          height: 160,
                          child: Center(
                            child: Image.asset(
                              'assets/images/delivery_boy.png', // your asset path
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
              // --- Categories Section (What's on your mind?) ---
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 12.0),
                child: Text(
                  "What's on your mind?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // Scrollable Grid for Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  height: 105, // Height to fit 1 row of category items
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal, // Horizontal scroll
                    padding: EdgeInsets.zero,
                    itemCount: categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1, // One row
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 1.25, // Adjust item width
                        ),
                    itemBuilder: (context, index) {
                      return _buildCategoryItem(categories[index]);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- Kitchens Section (Explore Kitchens) ---
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 12.0),
                child: Text(
                  "Explore Kitchens",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // Horizontal Scrollable List for Kitchen Cards
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
                            builder: (context) => MessMenuScreen(mess: [messes[index]]), // Wrap in a list
                          ),
                        );
                      },
                      child: _buildKitchenCard(messes[index]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 25),

              // --- Explore by Dishes Button ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Action for Explore by Dishes
                      print("Explore by Dishes tapped!");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF870474), // Purple color
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

              const SizedBox(height: 30), // Extra space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
