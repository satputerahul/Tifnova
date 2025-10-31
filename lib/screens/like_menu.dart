import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'home_screen.dart';

class LikeMenu extends StatefulWidget {
  final List<Map<String, String>> favoriteList;
  final List<Map<String, String>> allMesses;

  const LikeMenu({
    super.key,
    required this.favoriteList,
    required this.allMesses,
  });

  @override
  State<LikeMenu> createState() => _LikeMenuState();
}

class _LikeMenuState extends State<LikeMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF870474),
        title: const Text(
          'My Favorites ❤️',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/back.png', // 👈 your custom back icon
            width: 24,
            height: 24,
            color: Colors.black, // makes sure it’s visible on purple background
          ),
          onPressed: () {
            Navigator.pop(context); // go back to the previous screen
          },
        ),
      ),
      body: widget.favoriteList.isEmpty
          ? const Center(
              child: Text(
                'No favorites yet 😕',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: widget.favoriteList.length,
              itemBuilder: (context, index) {
                final mess = widget.favoriteList[index];
                return _buildFavoriteCard(mess);
              },
            ),
    );
  }

  Widget _buildFavoriteCard(Map<String, String> mess) {
    return GestureDetector(
      onTap: () {
        // Navigate to mess details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MessListScreen(mess: [mess], allMesses: widget.allMesses),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: Image.asset(
                mess['image']!,
                width: 100,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mess['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mess['description']!,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFFC107),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          mess['rating']!,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.favoriteList.remove(mess);
                              Fluttertoast.showToast(
                                msg: "${mess['name']} removed from Likes",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.black54,
                                textColor: Colors.white,
                              );
                            });
                          },
                          child: Image.asset(
                            'assets/icons/unlike.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ],
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
