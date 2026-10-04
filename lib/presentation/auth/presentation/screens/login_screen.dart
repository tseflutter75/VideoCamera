import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:videocall/app/url.dart';
import 'package:videocall/core/services/network_caller.dart';
import 'package:videocall/presentation/auth/data/models/user_model.dart';
import 'package:videocall/presentation/auth/presentation/AuthController.dart';
import 'package:videocall/presentation/home/screens/home_doctorList_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailcontroller;
  late TextEditingController _passwordcontroller;

  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool inprogresslogin = false;

  @override
  void initState() {
    super.initState();

    _emailcontroller = TextEditingController();
    _passwordcontroller = TextEditingController();

    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    const storage = FlutterSecureStorage();

    final savedUsername = await storage.read(key: 'saved_username');
    final savedPassword = await storage.read(key: 'saved_password');

    if (savedUsername != null) _emailcontroller.text = savedUsername;
    if (savedPassword != null) _passwordcontroller.text = savedPassword;
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _fromKey,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 120),

                  const SizedBox(height: 60),
                  Text(
                    "Sign In to Continue",
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 32, 0, 87),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  ///    /////////////////////////////////////////////////
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _emailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,

                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),

                      hintText: "Username / Email",

                      hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "enter the email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 26),

                  TextFormField(
                    controller: _passwordcontroller,
                    obscureText: _obscurePassword,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: Icon(Icons.lock_outline),

                      hintText: "Enter Password",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                      filled: true,
                      fillColor: Colors.white,

                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),

                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "enter the correct password";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 5),
                  Row(
                    children: [
                      Spacer(),
                      Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 140, 255),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  Visibility(
                    visible: inprogresslogin == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: Container(
                      width: 370,
                      height:
                          56, // Adjusted slightly for better proportions with the design
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          20,
                        ), // High rounded corners
                        boxShadow: [
                          // Bottom ambient shadow
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                          // Bright bottom glow edge seen in your image
                          BoxShadow(
                            color: Colors.white.withOpacity(0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        // Outer light border/edge effect
                        border: Border.all(
                          color: Colors.white.withOpacity(0.6),
                          width: 1.5,
                        ),
                        // Base blue gradient background
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF1A8CFF), // Lighter blue at top
                            Color(0xFF0055D4), // Deeper blue at bottom
                          ],
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          children: [
                            // The Glossy Top Highlight Layer
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              height: 24, // Covers the top half
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white.withOpacity(0.4),
                                      Colors.white.withOpacity(0.05),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Interactive Material Layer for Tap Handling
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  if (_fromKey.currentState!.validate()) {
                                    _login();
                                  }
                                },
                                borderRadius: BorderRadius.circular(18),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Spacer(),
                                      // Centered Text
                                      Center(
                                        child: const Text(
                                          "Sign In",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      // Trailing Arrow Icon
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white.withOpacity(0.9),
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(text: 'New to this App? '),
                          TextSpan(
                            text: 'Create an Account',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 160),

                  Text(
                    "© 2026 HRXpert. All right reserved",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future<String> getAndroidId() async {
  //   final deviceinfo = DeviceInfoPlugin();
  //   final android = await deviceinfo.androidInfo;
  //   return android.id;
  // }

  // // login
  Future<void> _login() async {
    inprogresslogin = true;
    setState(() {});

    // String androidId = await getAndroidId();
    // String? androidId = await DeviceIdService.getDeviceId();

    final Map<String, dynamic> requestBody = {
      "email": _emailcontroller.text.trim(),
      "password": _passwordcontroller.text.trim(),
      // "android_id": androidId,
    };

    ApiResponse response = await NetworkCaller.postRequest(
      url: Urls.loginUrl,
      body: requestBody,
    );

    // 🔴 FIX-4: Safe check

    try {
      if (response.isSuccess && response.responseData["status"] == "success") {
        UserModel model = UserModel.fromJson(response.responseData["data"]);

        String accessToken = response.responseData["jwtToken"];
        // String? refreshToken = response.responseData["refreshToken"];

        await AuthController.saveUserData(model, accessToken);

        final storage = FlutterSecureStorage();

        // Login success হলে save করা
        await storage.write(
          key: 'saved_username',
          value: _emailcontroller.text.trim(),
        );

        await storage.write(
          key: 'saved_password',
          value: _passwordcontroller.text.trim(),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DoctorListScreen()),
        );
      } else {
        inprogresslogin = false;
        setState(() {});
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
            content: Center(
              child: Text(
                response.errorMessage,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      inprogresslogin = false;
      setState(() {});
      // ignore: use_build_context_synchronously
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
            content: Center(
              child: Text(
                response.errorMessage,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }
    }
  }
}
