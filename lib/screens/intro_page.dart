import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> _introData = [
    {
      "image": "assets/images/tifnova.png",
      "title": "Welcome to Tiffo",
      "description": "Order delicious meals and enjoy effortless delivery.",
    },
    {
      "image": "assets/images/cooking.png",
      "title": "Made Fresh in Every Meal",
      "description":
          "Delicious home-style food prepared fresh every single day.",
    },
    {
      "image": "assets/images/health.png",
      "title": "Eat Healthy, Stay Fit",
      "description":
          "Enjoy fresh and healthy meals made with care for your daily routine.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ✅ PageView for intro pages
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemCount: _introData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      _introData[index]["image"]!,
                      width: screenWidth * 0.7,
                      height: screenHeight * 0.35,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Text(
                      _introData[index]["title"]!,
                      style: TextStyle(
                        fontSize: screenWidth * 0.065,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF870474),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      _introData[index]["description"]!,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),

          // ✅ Bottom Dots + Next button
          Positioned(
            bottom: screenHeight * 0.05,
            left: screenWidth * 0.08,
            right: screenWidth * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dots
                Row(
                  children: List.generate(_introData.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.only(right: screenWidth * 0.015),
                      width: currentIndex == index
                          ? screenWidth * 0.035
                          : screenWidth * 0.02,
                      height: screenWidth * 0.02,
                      decoration: BoxDecoration(
                        color: currentIndex == index
                            ? Color(0xFF870474)
                            : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  }),
                ),

                // Next / Start button
                ElevatedButton(
                  onPressed: () {
                    if (currentIndex < _introData.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE7CDE3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08,
                      vertical: screenHeight * 0.015,
                    ),
                  ),
                  child: Text(
                    currentIndex < _introData.length - 1 ? "Next" : "Start",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      color: Color(0xFF870474),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
