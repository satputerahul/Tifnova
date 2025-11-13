import 'dart:io';

import 'package:Tifnova/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Map<String, String>> get mess => [];
  List<Map<String, String>> get allMesses => [];
  String? _selectedGender;
  DateTime? _selectedDate;
  XFile? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF870474),
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
                        CircleAvatar(
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
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Image.asset('assets/icons/edit_profile.png', width: 30, height: 30),
                            onPressed: _pickImage,
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
                  icon: Image.asset('assets/icons/back.png', width: 24, height: 24),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => MessListScreen(mess: mess, allMesses: allMesses),
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
                    const Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                    _buildTextFieldWithIcon('Name'),
                    // Mobile Field
                    const Text('Mobile', style: TextStyle(fontWeight: FontWeight.bold)),
                    _buildTextFieldWithIcon('Mobile'),
                    // Email Field
                    const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                    _buildTextFieldWithIcon('Email'),
                    // Date of Birth Field
                    const Text('Date of Birth', style: TextStyle(fontWeight: FontWeight.bold)),
                    _buildDateField(context),
                    // Gender Field
                    const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
                    _buildGenderDropdown(),
                    const SizedBox(height: 50),
                    // Update Profile Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF870474),
                          padding: const EdgeInsets.all(12),
                        ),
                        child: const Text(
                          'Update profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithIcon(String label) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: label,
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            IconButton(
              icon: Image.asset(
                'assets/icons/edit.png',
                width: 30,
                height: 30,
                color: Color(0xFF870474),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedDate != null
                    ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                    : 'Select Date',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            IconButton(
              icon: Image.asset(
                'assets/icons/calendar.png',
                width: 30,
                height: 30,
                color: Color(0xFF870474),
              ),
              onPressed: () => _selectDate(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(border: InputBorder.none),
          hint: const Text('Select Gender'),
          value: _selectedGender,
          items: ['Male', 'Female'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
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
      size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
