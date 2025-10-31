import 'package:Tifnova/screens/home_screen.dart';
import 'package:Tifnova/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color primaryColor = Color(0xFF870474);
  static const Color hintColor = Color(0xFFB0B0B0);
  static const Color borderColor = Color(0xFFE0E0E0);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    /*
    if (email.isEmpty && password.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter email and password",
        backgroundColor: Colors.red,
      );
    } else if (email.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter email",
        backgroundColor: Colors.red,
      );
    } else if (password.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter password",
        backgroundColor: Colors.red,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Login Successful",
        backgroundColor: Colors.green,
      );
    } 
    */

    //Navigate to Home Screen
    _homeScreen();
  }

  void _forgotPassword() {
    Fluttertoast.showToast(
      msg: 'Forgot password clicked!',
      backgroundColor: const Color(0xFF870474),
    );
  }

  void _signUp() {
    Fluttertoast.showToast(
      msg: 'Sign up clicked!',
      backgroundColor: const Color(0xFF870474),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  void _homeScreen() {
    Fluttertoast.showToast(
      msg: 'Navigate to Home Screen',
      backgroundColor: Colors.grey,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MessListScreen(mess: [], allMesses: [],)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // ✅ Automatically scroll if height < 600px
            bool isSmallScreen = constraints.maxHeight < 600;
            Widget content = _buildLoginContent(context);

            return isSmallScreen
                ? SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: content,
                  )
                : content;
          },
        ),
      ),
    );
  }

  // --- Core Login Layout ---
  Widget _buildLoginContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.08,
        vertical: screenHeight * 0.035,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Title ---
          Text(
            'Sign in to your\naccount',
            style: TextStyle(
              fontSize: screenWidth * 0.075,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: screenHeight * 0.015),

          Text(
            'Sign in to access your favorite meals and manage orders easily.',
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: screenHeight * 0.05),

          // --- Email ---
          Text(
            'Email Address',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: screenHeight * 0.008),
          _buildInputField(
            controller: _emailController,
            hintText: 'Enter your Email',
            screenWidth: screenWidth,
            screenHeight: screenHeight,
          ),
          SizedBox(height: screenHeight * 0.025),

          // --- Password ---
          Text(
            'Password',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: screenHeight * 0.008),
          _buildPasswordInputField(
            controller: _passwordController,
            hintText: 'Enter an Password',
            screenWidth: screenWidth,
            screenHeight: screenHeight,
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _forgotPassword,
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),

          // --- Login Button ---
          SizedBox(
            width: double.infinity,
            height: screenHeight * 0.065,
            child: ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.04),

          // --- Divider ---
          Row(
            children: [
              const Expanded(child: Divider(color: borderColor)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                child: Text(
                  'Or sign in with',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: screenWidth * 0.035,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: borderColor)),
            ],
          ),
          SizedBox(height: screenHeight * 0.04),

          // --- Social Buttons ---
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(
                imagePath: "assets/icons/google.png",
                size: screenWidth * 0.15,
                onPressed: () {
                  Fluttertoast.showToast(msg: "Google login clicked");
                },
              ),
              SizedBox(width: screenWidth * 0.08),
              _buildSocialButton(
                imagePath: "assets/icons/apple.png",
                size: screenWidth * 0.15,
                onPressed: () {
                  Fluttertoast.showToast(msg: "Apple login clicked");
                },
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.05),

          // --- Sign Up Link ---
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: _signUp,
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Email Input Field ---
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.black),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.015,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor, fontSize: screenWidth * 0.04),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // --- Password Input Field ---
  Widget _buildPasswordInputField({
    required TextEditingController controller,
    required String hintText,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        obscureText: !_isPasswordVisible,
        style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.black),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.015,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor, fontSize: screenWidth * 0.04),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: hintColor,
              size: screenWidth * 0.06,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
      ),
    );
  }

  // --- Social Button ---
  Widget _buildSocialButton({
    required String imagePath,
    required double size,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey, width: 0.5),
        ),
        child: Padding(
          padding: EdgeInsets.all(size * 0.25),
          child: Image.asset(imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
