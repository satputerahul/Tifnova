import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OTPVerificationPage extends StatefulWidget {
  final String mobileNumber;

  const OTPVerificationPage({super.key, required this.mobileNumber});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _verificationId;
  bool _isLoading = false;

  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());
    _sendOTP();
  }

  // 🔹 Send OTP via Firebase
  Future<void> _sendOTP() async {
    setState(() => _isLoading = true);
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91${widget.mobileNumber}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        Fluttertoast.showToast(msg: "✅ Auto Verified Successfully");
      },
      verificationFailed: (FirebaseAuthException e) {
        Fluttertoast.showToast(msg: "Verification Failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isLoading = false;
        });
        Fluttertoast.showToast(msg: "📩 OTP Sent Successfully");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
      timeout: const Duration(seconds: 60),
    );
  }

  // 🔹 Verify OTP
  Future<void> _verifyOTP() async {
    String otp = _otpControllers.map((c) => c.text).join();

    if (otp.length != 6) {
      Fluttertoast.showToast(msg: "Please enter the complete 6-digit OTP");
      return;
    }

    setState(() => _isLoading = true);

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      Fluttertoast.showToast(msg: "✅ OTP Verified Successfully!");
      // Navigate to next screen if needed
    } catch (e) {
      Fluttertoast.showToast(msg: "❌ Invalid OTP, try again.");
    }

    setState(() => _isLoading = false);
  }

  // 🔹 Handle OTP field focus change
  void _handleOtpChange(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    } else if (index == 5 && value.isNotEmpty) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Back button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // Image
              Image.asset(
                'assets/images/otp.png',
                height: screenHeight * 0.3,
                width: screenWidth * 0.95,
                fit: BoxFit.contain,
              ),

              // Title + Subtitle
              Column(
                children: [
                  const Text(
                    "Verification",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Enter the 6-digit code sent to +91 ${widget.mobileNumber}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ],
              ),

              // OTP Boxes (6)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 45,
                      height: 60,
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        cursorColor: const Color(0xFF8B2B9A),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          counterText: "",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF8B2B9A),
                              width: 1.6,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF8B2B9A),
                              width: 2.2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          _handleOtpChange(value, index);
                        },
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 15),

              // Verify Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B2B9A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Verify",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 15),

              // Resend Text
              Column(
                children: [
                  const Text(
                    "Didn't receive any code?",
                    style: TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: _sendOTP,
                    child: const Text(
                      "Resend New Code",
                      style: TextStyle(
                        color: Color(0xFF8B2B9A),
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
