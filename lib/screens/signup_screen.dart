import 'package:Tifnova/screens/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  static const Color primaryColor = Color(0xFF870474);
  static const Color hintColor = Color(0xFFB0B0B0);
  static const Color borderColor = Color(0xFFE0E0E0);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPasswordVisible = false;
  bool _isTermsChecked = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 🔹 Send OTP through Firebase
  void _register() async {
    String email = _emailController.text.trim();
    String mobile = _mobileController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || mobile.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill all required fields",
        backgroundColor: Colors.red,
      );
      return;
    }

    if (!_isTermsChecked) {
      Fluttertoast.showToast(
        msg: "Please agree to Terms and Privacy Policy",
        backgroundColor: Colors.red,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91$mobile",
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto verification (Android)
          await _auth.signInWithCredential(credential);
          Fluttertoast.showToast(msg: "Auto verified successfully!");
        },
        verificationFailed: (FirebaseAuthException e) {
          Fluttertoast.showToast(
            msg: "Verification failed: ${e.message}",
            backgroundColor: Colors.red,
          );
          setState(() => _isLoading = false);
        },
        codeSent: (String verificationId, int? resendToken) {
          Fluttertoast.showToast(
            msg: "OTP sent to +91$mobile",
            backgroundColor: Colors.green,
          );

          setState(() => _isLoading = false);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationPage(mobileNumber: mobile),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() => _isLoading = false);
        },
      );
    } catch (e) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}",
        backgroundColor: Colors.red,
      );
    }
  }

  void _signIn() {
    Fluttertoast.showToast(
      msg: 'Navigating to Sign In',
      backgroundColor: primaryColor,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width * 0.9;
    final screenHeight = MediaQuery.of(context).size.height * 0.9;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08,
            vertical: screenHeight * 0.03,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Title ---
                Text(
                  'Create your new\naccount',
                  style: TextStyle(
                    fontSize: screenWidth * 0.085,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.008),

                Text(
                  'Create an account to explore your favorite meals and manage orders easily.',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                _buildLabel('Email Address', screenWidth),
                SizedBox(height: screenHeight * 0.008),
                _buildInputField(
                  controller: _emailController,
                  hintText: 'Enter your Email',
                  keyboardType: TextInputType.emailAddress,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                SizedBox(height: screenHeight * 0.02),

                _buildLabel('Mobile Number', screenWidth),
                SizedBox(height: screenHeight * 0.008),
                _buildMobileInputField(
                  controller: _mobileController,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                SizedBox(height: screenHeight * 0.02),

                _buildLabel('Password', screenWidth),
                SizedBox(height: screenHeight * 0.008),
                _buildPasswordInputField(
                  controller: _passwordController,
                  hintText: 'Enter a Password',
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                SizedBox(height: screenHeight * 0.02),

                _buildTermsAndPrivacy(screenWidth),
                SizedBox(height: screenHeight * 0.025),

                // --- Register Button ---
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.065,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Register',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                // --- Divider ---
                Row(
                  children: [
                    const Expanded(child: Divider(color: borderColor)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                      ),
                      child: Text(
                        'Or sign up with',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: screenWidth * 0.037,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: borderColor)),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),

                // --- Social Buttons ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                      imagePath: "assets/icons/google.png",
                      size: screenWidth * 0.15,
                      onPressed: () {
                        Fluttertoast.showToast(msg: "Google signup clicked");
                      },
                    ),
                    SizedBox(width: screenWidth * 0.08),
                    _buildSocialButton(
                      imagePath: "assets/icons/apple.png",
                      size: screenWidth * 0.15,
                      onPressed: () {
                        Fluttertoast.showToast(msg: "Apple signup clicked");
                      },
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.04),

                // --- Sign In Link ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: _signIn,
                      child: Text(
                        'Sign in',
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
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets (same as before) ---
  Widget _buildLabel(String text, double screenWidth) {
    return Text(
      text,
      style: TextStyle(
        fontSize: screenWidth * 0.04,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required double screenWidth,
    required double screenHeight,
    required TextInputType keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
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

  Widget _buildMobileInputField({
    required TextEditingController controller,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.04,
              right: screenWidth * 0.02,
            ),
            child: Text(
              '+91',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(height: screenHeight * 0.05, width: 1, color: borderColor),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.015,
                ),
                hintText: 'Enter Mobile Number',
                hintStyle: TextStyle(
                  color: hintColor,
                  fontSize: screenWidth * 0.04,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _buildTermsAndPrivacy(double screenWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: _isTermsChecked,
          onChanged: (bool? value) {
            setState(() {
              _isTermsChecked = value ?? false;
            });
          },
          activeColor: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        SizedBox(width: screenWidth * 0.02),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: 'I Agree with ',
              style: TextStyle(
                fontSize: screenWidth * 0.038,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

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
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Padding(
          padding: EdgeInsets.all(size * 0.22),
          child: Image.asset(imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
