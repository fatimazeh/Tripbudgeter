import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency/User/Auth/Signup_page.dart';
import 'package:currency/User/Auth/forgot.dart';
import 'package:currency/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> userLogin(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showDialog(context, "Please enter your email and password.", Icons.error,
          Colors.red);
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          _showDialog(
            context,
            "Login Successfully ",
            Icons.check_circle,
            Color(0xFF05a4c8),
          ).then((_) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LayoutScreen()));
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.code == "invalid-email"
          ? "No user found for the email."
          : "Wrong password provided.";
      _showDialog(context, errorMessage, Icons.error, Colors.red);
    }
  }

  Future<void> _showDialog(
      BuildContext context, String message, IconData icon, Color iconColor) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              Icon(icon, color: iconColor, size: 30),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF05a4c8),
                Color.fromARGB(255, 183, 127, 127),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          "Please enter your credentials to access your travel budget management tools. Log in to continue.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildTextField("Please enter Email", emailController),
                      const SizedBox(height: 20),
                      _buildTextField(
                          "Please enter Password", passwordController,
                          obscureText: true),
                      const SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF05a4c8),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              userLogin(context);
                            }
                          },
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordScreen()),
                            );
                          },
                          child: const Text(
                            "Forgot Password?",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        },
                        child: const Text(
                          "Don't have an account? Sign Up",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 80.0),
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.white,
                                  Color(0xFF05a4c8),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 2,
                right: 50,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.white,
                        Color(0xFF05a4c8),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $hint';
        }
        return null;
      },
    );
  }
}
