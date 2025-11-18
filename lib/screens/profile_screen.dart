import 'dart:io';

import 'package:Tifnova/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Map<String, String>> get mess => [];
  List<Map<String, String>> get allMesses => [];

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDate;
  XFile? _image;

  // Profile data storage
  Map<String, dynamic> profileData = {};

  // Edit mode flags
  bool _isNameEditable = false;
  bool _isMobileEditable = false;
  bool _isEmailEditable = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ??
          DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF870474)),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showProfileImageDialog() {
    if (_image != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: FileImage(File(_image!.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void _updateProfile() {
    // Validation
    if (_nameController.text.isEmpty) {
      _showSnackBar('Please enter your name');
      return;
    }
    if (_mobileController.text.isEmpty) {
      _showSnackBar('Please enter your mobile number');
      return;
    }
    if (_emailController.text.isEmpty) {
      _showSnackBar('Please enter your email');
      return;
    }
    if (_selectedDate == null) {
      _showSnackBar('Please select your date of birth');
      return;
    }
    if (_selectedGender == null) {
      _showSnackBar('Please select your gender');
      return;
    }

    // Store data in map
    profileData = {
      'name': _nameController.text,
      'mobile': _mobileController.text,
      'email': _emailController.text,
      'dateOfBirth': DateFormat('dd/MM/yyyy').format(_selectedDate!),
      'gender': _selectedGender!,
      'profileImage': _image?.path ?? '',
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Disable all fields after update
    setState(() {
      _isNameEditable = false;
      _isMobileEditable = false;
      _isEmailEditable = false;
    });

    // Show success message
    _showSnackBar('Profile updated successfully!');

    // Print to console (for debugging)
    print('Profile Data: $profileData');

    // You can also save to SharedPreferences or database here
    // Example: await SharedPreferences.getInstance().setString('profile', jsonEncode(profileData));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF870474),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom curved header with back button and profile photo
          Stack(
            children: [
              CustomPaint(
                painter: CurvePainter(),
                child: Container(
                  height: 250,
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: _showProfileImageDialog,
                          child: Hero(
                            tag: 'profile_image',
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: _image != null
                                  ? ClipOval(
                                      child: Image.file(
                                        File(_image!.path),
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      ),
                                    )
                                  : const Text(
                                      'R',
                                      style: TextStyle(
                                        fontSize: 40,
                                        color: Color(0xFF870474),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Image.asset(
                                'assets/icons/edit_profile.png',
                                width: 24,
                                height: 24,
                              ),
                              onPressed: _pickImage,
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 10,
                child: IconButton(
                  icon: Image.asset(
                    'assets/icons/back.png',
                    width: 24,
                    height: 24,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) =>
                            MessListScreen(mess: mess, allMesses: allMesses),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
          // Profile fields
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Field
                    const Text(
                      'Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextFieldWithIcon(
                      'Enter your name',
                      _nameController,
                      isEditable: _isNameEditable,
                      onEditPressed: () {
                        setState(() {
                          _isNameEditable = !_isNameEditable;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Mobile Field
                    const Text(
                      'Mobile',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextFieldWithIcon(
                      'Enter mobile number',
                      _mobileController,
                      isNumber: true,
                      isEditable: _isMobileEditable,
                      onEditPressed: () {
                        setState(() {
                          _isMobileEditable = !_isMobileEditable;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email Field
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextFieldWithIcon(
                      'Enter email address',
                      _emailController,
                      isEmail: true,
                      isEditable: _isEmailEditable,
                      onEditPressed: () {
                        setState(() {
                          _isEmailEditable = !_isEmailEditable;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Date of Birth Field
                    const Text(
                      'Date of Birth',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDateField(context),
                    const SizedBox(height: 16),

                    // Gender Field
                    const Text(
                      'Gender',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildGenderDropdown(),
                    const SizedBox(height: 50),

                    // Update Profile Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF870474),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          'Update profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithIcon(
    String hint,
    TextEditingController controller, {
    bool isNumber = false,
    bool isEmail = false,
    required bool isEditable,
    required VoidCallback onEditPressed,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                readOnly: !isEditable,
                keyboardType: isNumber
                    ? TextInputType.phone
                    : isEmail
                    ? TextInputType.emailAddress
                    : TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                style: TextStyle(
                  color: isEditable ? Colors.black87 : Colors.grey[600],
                ),
              ),
            ),
            IconButton(
              icon: Image.asset(
                'assets/icons/edit.png',
                width: 24,
                height: 24,
                color: isEditable ? const Color(0xFF870474) : Colors.grey,
              ),
              onPressed: onEditPressed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _selectDate(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                      : 'Select your date of birth',
                  style: TextStyle(
                    color: _selectedDate != null
                        ? Colors.black87
                        : Colors.grey[400],
                    fontSize: 16,
                  ),
                ),
              ),
              Image.asset(
                'assets/icons/calendar.png',
                width: 24,
                height: 24,
                color: const Color(0xFF870474),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
          hint: Text(
            'Select your gender',
            style: TextStyle(color: Colors.grey[400]),
          ),
          value: _selectedGender,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF870474)),
          items: ['Male', 'Female', 'Other'].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedGender = newValue;
            });
          },
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = const Color(0xFF870474);
    final Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
