import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:Tifnova/screens/help.dart';
import 'package:Tifnova/screens/location_map_screen.dart';
import 'package:Tifnova/screens/profile_screen.dart';
import 'package:Tifnova/screens/like_menu.dart';
import 'package:Tifnova/screens/messMenu_screen.dart';
import 'package:Tifnova/screens/language_provider.dart';
import 'package:Tifnova/screens/theme_notifier.dart';
import 'package:Tifnova/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addCart.dart';

class MessListScreen extends StatefulWidget {
  const MessListScreen({
    super.key,
    required List<Map<String, String>> mess,
    required List<Map<String, String>> allMesses,
  });

  @override
  State<MessListScreen> createState() => _MessListScreenState();
}

class _MessListScreenState extends State<MessListScreen>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _cartItemCount = 0;
  final double _cartTotalPrice = 120.0;
  String _currentAddress = '';
  String _currentLocality = '';
  double? _currentLatitude;
  double? _currentLongitude;
  List<Map<String, dynamic>> cartItems = [];
  List<Map<String, String>> favoriteList = [];
  bool _hasAskedForLocation = false;
  bool _isFirstTime = true;
  final TextEditingController _searchController = TextEditingController();
  bool _isCheckingLocation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkLocationPermissionStatus();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstTime = prefs.getBool('first_time_location') ?? true;
    if (_isFirstTime) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLocationDialog();
      });
    }
  }

  Future<void> _markFirstTimeFalse() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time_location', false);
  }

  Future<void> _checkLocationPermissionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _hasAskedForLocation = prefs.getBool('hasAskedForLocation') ?? false;
  }

  Future<void> _markLocationAsAsked() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasAskedForLocation', true);
    setState(() {
      _hasAskedForLocation = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentAddress = AppLocalizations.of(context)!.enableLocation;
    _currentLocality = AppLocalizations.of(context)!.setLocation;
    _getCurrentLocationIfNeeded();
  }

  Future<void> _getCurrentLocationIfNeeded() async {
    if (!_hasAskedForLocation) {
      await _getCurrentLocation();
    } else {
      await _checkAndFetchLocationSilently();
    }
  }

  Future _checkAndFetchLocationSilently() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
      await _fetchCurrentLocation();
    } catch (e) {
      // Silently fail
    }
  }

  Future<void> _fetchCurrentLocation() async {
    if (_isCheckingLocation) return;
    _isCheckingLocation = true;

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        Placemark placemark = placemarks[0];
        setState(() {
          _currentLatitude = position.latitude;
          _currentLongitude = position.longitude;
          _currentAddress = placemark.subLocality ??
              placemark.name ??
              placemark.street ??
              placemark.thoroughfare ??
              AppLocalizations.of(context)!.setLocation;
          _currentLocality =
              placemark.locality ?? AppLocalizations.of(context)!.setLocation;
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = AppLocalizations.of(context)!.enableLocation;
        _currentLocality = AppLocalizations.of(context)!.setLocation;
      });
    } finally {
      _isCheckingLocation = false;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _checkAndFetchLocationSilently();
    }
  }

  Future<void> _checkAndFetchLocation() async {
    await _checkAndFetchLocationSilently();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _currentAddress = AppLocalizations.of(context)!.fetchingLocation;
      _currentLocality = AppLocalizations.of(context)!.fetchingLocality;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!_hasAskedForLocation) {
          bool? shouldOpenSettings = await _showLocationDialog();
          if (shouldOpenSettings == true) {
            await Geolocator.openLocationSettings();
            // Wait for user to return from settings
            await Future.delayed(const Duration(seconds: 1));
            // Check location again after returning from settings
            await _checkAndFetchLocationSilently();
          }
          await _markLocationAsAsked();
        }
        setState(() {
          _currentAddress = AppLocalizations.of(context)!.enableLocation;
          _currentLocality = AppLocalizations.of(context)!.setLocation;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        await _markLocationAsAsked();

        if (permission == LocationPermission.denied) {
          if (!_hasAskedForLocation) {
            bool? shouldOpenSettings = await _showPermissionDialog();
            if (shouldOpenSettings == true) {
              await Geolocator.openAppSettings();
              // Wait for user to return from settings
              await Future.delayed(const Duration(seconds: 1));
              // Check location again after returning from settings
              await _checkAndFetchLocationSilently();
            }
          }
          setState(() {
            _currentAddress = AppLocalizations.of(context)!.enableLocation;
            _currentLocality = AppLocalizations.of(context)!.setLocation;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!_hasAskedForLocation) {
          bool? shouldOpenSettings = await _showPermissionDialog();
          if (shouldOpenSettings == true) {
            await Geolocator.openAppSettings();
            // Wait for user to return from settings
            await Future.delayed(const Duration(seconds: 1));
            // Check location again after returning from settings
            await _checkAndFetchLocationSilently();
          }
          await _markLocationAsAsked();
        }
        setState(() {
          _currentAddress = AppLocalizations.of(context)!.enableLocation;
          _currentLocality = AppLocalizations.of(context)!.setLocation;
        });
        return;
      }

      // Permission granted - fetch location
      await _fetchCurrentLocation();
    } catch (e) {
      setState(() {
        _currentAddress = AppLocalizations.of(context)!.enableLocation;
        _currentLocality = AppLocalizations.of(context)!.setLocation;
      });
    }
  }

  Future<bool?> _showLocationDialog() async {
    final loc = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            loc.locationServicesDisabled,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Text(
            loc.enableLocationDesc,
            style: const TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                loc.cancel,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                _markFirstTimeFalse();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF870474),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                loc.ok,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showPermissionDialog() async {
    final loc = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            loc.permissionRequired,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Text(
            loc.permissionDesc,
            style: const TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                loc.cancel,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF870474),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                loc.openSettings,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    await _checkAndFetchLocationSilently();
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

  Widget _buildKitchenCard(
      Map<String, String> mess, List<Map<String, String>> allMesses) {
    bool isLiked = favoriteList.any((item) => item['name'] == mess['name']);

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
                      builder: (context) => MessMenuScreen(
                        mess: [mess],
                        allMesses: allMesses,
                      ),
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
                      if (isLiked) {
                        favoriteList.removeWhere(
                            (item) => item['name'] == mess['name']);
                        Fluttertoast.showToast(
                          msg: '${mess['name']} removed from likes',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                        );
                      } else {
                        favoriteList.add(mess);
                        Fluttertoast.showToast(
                          msg: '${mess['name']} added to likes',
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
                      isLiked
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
                        color: mess['delivery']!.toLowerCase() == 'free'
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final loc = AppLocalizations.of(context)!;
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
                Image.asset('assets/images/tifnova.png', height: 80, width: 80),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello,',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
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
                  leading: const Icon(Icons.home_outlined),
                  title: Text(loc.home),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(loc.changeLanguage),
                  trailing: DropdownButton<String>(
                    value: languageProvider.currentLocale.languageCode,
                    items: const [
                      DropdownMenuItem(value: "en", child: Text("English")),
                      DropdownMenuItem(value: "mr", child: Text("मराठी")),
                      DropdownMenuItem(value: "hi", child: Text("हिंदी")),
                    ],
                    onChanged: (value) {
                      languageProvider.changeLanguage(value!);
                    },
                  ),
                ),
                SwitchListTile(
                  title: Text(loc.darkMode),
                  secondary: const Icon(Icons.dark_mode),
                  value: themeProvider.isDark,
                  onChanged: (value) => themeProvider.toggleTheme(),
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: Text(loc.help),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HelpPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(loc.yourAccount),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share_outlined),
                  title: Text(loc.shareApp),
                  onTap: () {
                    Share.share("Hey! Check out this awesome app:");
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFF870474)),
            title: Text(loc.logout),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final loc = AppLocalizations.of(context)!;
    final l10n = AppLocalizations.of(context)!;
    final categories = getLocalizedCategories(l10n);
    final messes = getLocalizedMesses(l10n);

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: const Color(0xFF870474),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      children: [
                        Expanded(
                          child: Row(
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
                                onTap: () async {
                                  // First try to get location silently
                                  bool locationFetched =
                                      await _checkAndFetchLocationSilently();

                                  if (!locationFetched) {
                                    // If silent check fails, show location screen
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LocationMapScreen(
                                          initialLatitude: _currentLatitude,
                                          initialLongitude: _currentLongitude,
                                          currentAddress: _currentAddress,
                                        ),
                                      ),
                                    );
                                    if (result != null && result is Map) {
                                      setState(() {
                                        _currentLatitude = result['latitude'];
                                        _currentLongitude = result['longitude'];
                                        String fullAddress = result['address'];
                                        List<String> parts =
                                            fullAddress.split(',');
                                        if (parts.length >= 2) {
                                          _currentAddress = parts[0].trim();
                                          _currentLocality = parts[1].trim();
                                        } else {
                                          _currentAddress = fullAddress;
                                        }
                                      });
                                    }
                                  }
                                },
                                child: _customAssetImage(
                                  'assets/icons/location.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _currentLocality,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      _currentAddress,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
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
                                  child: _customAssetImage(
                                    'assets/icons/like.png',
                                    width: 35,
                                    height: 35,
                                  ),
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
                                GestureDetector(
                                  onTap: () async {
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
                                            List<Map<String, dynamic>>.from(
                                          updatedCart,
                                        );
                                        _cartItemCount = cartItems.length;
                                      });
                                    }
                                  },
                                  child: _customAssetImage(
                                    'assets/icons/cart.png',
                                    width: 35,
                                    height: 35,
                                  ),
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
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 8.0),
                          child: Icon(Icons.search, color: Colors.grey[600]),
                        ),
                        hintText: loc.searchHint,
                        suffixIcon: Padding(
                          padding:
                              const EdgeInsets.only(right: 12.0, left: 8.0),
                          child:
                              Icon(Icons.filter_list, color: Colors.grey[600]),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0),
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
                          children: [
                            Text(
                              loc.tifnovaAt,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              loc.yourService,
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
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 12.0),
                child: Text(
                  loc.whatsOnYourMind,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 12.0),
                child: Text(
                  loc.exploreByDishes,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
                      child: _buildKitchenCard(messes[index], messes),
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF870474),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      loc.exploreByDishes,
                      style: const TextStyle(
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
        ),
      ),
    );
  }

  List<Map<String, String>> getLocalizedMesses(AppLocalizations l10n) {
    return [
      {
        "name": "Patil Mess",
        "description": l10n.patilMessDesc,
        "rating": "4.7",
        "image": "assets/images/PatilKhanawal.png",
        "time": "20 ${l10n.min}",
        "delivery": l10n.freeDelivery,
      },
      {
        "name": "Sadanand Upharagruha",
        "description": l10n.sadanandDesc,
        "rating": "4.7",
        "image": "assets/images/sadanandUphargruha.png",
        "time": "20 ${l10n.min}",
        "delivery": l10n.freeDelivery,
      },
      {
        "name": "Annapurna Mess",
        "description": l10n.annapurnaDesc,
        "rating": "4.3",
        "image": "assets/images/AnnapurnaMess.jpeg",
        "time": "30 ${l10n.min}",
        "delivery": "₹20",
      },
      {
        "name": "Amruta Mess",
        "description": l10n.amrutaDesc,
        "rating": "4.6",
        "image": "assets/images/AmrutaMess.jpeg",
        "time": "25 ${l10n.min}",
        "delivery": l10n.freeDelivery,
      },
      {
        "name": "Swadistam",
        "description": l10n.swadistamDesc,
        "rating": "4.6",
        "image": "assets/images/Swadistam.png",
        "time": "25 ${l10n.min}",
        "delivery": l10n.freeDelivery,
      },
    ];
  }

  List<Map<String, String>> getLocalizedCategories(l10n) {
    return [
      {"name": l10n.thali, "image": "assets/images/thali.png"},
      {"name": l10n.vegetable, "image": "assets/images/vegetable.png"},
      {"name": l10n.chicken, "image": "assets/images/chicken.png"},
      {"name": l10n.snacks, "image": "assets/images/snaks.png"},
      {"name": l10n.paratha, "image": "assets/images/paratha.jpeg"},
      {"name": l10n.southIndian, "image": "assets/images/southIndian.jpeg"},
    ];
  }
}
