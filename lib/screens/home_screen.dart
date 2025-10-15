import 'package:flutter/material.dart';

class MessListScreen extends StatefulWidget {
  const MessListScreen({super.key});

  @override
  State<MessListScreen> createState() => _MessListScreenState();
}

class _MessListScreenState extends State<MessListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Helper widget to load custom Image assets
  Widget _customAssetImage(
    String assetPath, {
    Color? color,
    double? width,
    double? height,
  }) {
    // You should use your actual image loading logic here.
    // Assuming Image.asset is correct for your setup.
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      color: color,
      fit: BoxFit.contain,
    );
  }

  // Drawer (Sidebar)
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
                  'assets/images/tiffo.png',
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logging out...')),
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

  // Main Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header Section
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
                        padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                        child: _customAssetImage(
                          'assets/icons/search.png',
                          color: Colors.grey,
                          width: 20,
                          height: 20,
                        ),
                      ),
                      hintText: 'Search menu, kitchens or etc',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 12.0, left: 8.0),
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

            // ✨ MODIFIED GRADIENT BANNER SECTION ✨
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
                      Color(0xFF421B86) // Right color
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                // Replaced Row with Stack to allow for overlapping/off-boundary positioning
                child: Stack(
                  children: [
                    // Left side - Text (using Positioned to center vertically)
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
                              fontSize: 28, // Adjusted size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'your service!',
                            style: TextStyle(
                              color: Colors.white, // Adjusted color
                              fontSize: 18, // Adjusted size
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Right side - Circular image container positioned off-screen
                    Positioned(
                      // Pushes the center of the circle slightly off the right edge
                      right: -30, 
                      // Vertically center the 150-height circle in the 130-height container
                      top: (130 - 150) / 2, 
                      child: Container(
                        width: 150, // Circle diameter
                        height: 150,
                        decoration: BoxDecoration(
                          // The slightly lighter purple circle background
                          //color: const Color(0xFF6B429A), 
                          borderRadius: BorderRadius.circular(75), // Radius is half the width/height
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/delivery_boy.png', // your asset path
                            width: 115, // Size of the illustration within the circle
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}