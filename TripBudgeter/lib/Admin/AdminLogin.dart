import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency/Admin/web_main.dart';
import 'package:currency/models/shared_pref_admin.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  static const String id = "AdminLogin";

  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  SharedPreferenceHelper sharedPrefHelper =
      SharedPreferenceHelper(); // Correct class name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient container
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white, // White
                  Color(0xFF05A4C8), // New blue shade
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Top-left corner: Small logo
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              width: 150, // Adjust the size of the logo
              height: 100, // Adjust the size of the logo
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      '../assets/Logo/TripGif.gif'), // Path to your small logo image
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // Main content container
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 6),
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF), // White
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30.0),
                    const Center(
                      child: Icon(
                        Icons.lock, // Icon for privacy/protection
                        size: 60.0,
                        color: Color(0xFF05A4C8), // New blue shade
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Center(
                      child: Text(
                        "Secure Admin Login",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Black
                          fontFamily: 'Syne',
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Fill the following Credentials to get Access",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Black
                          fontFamily: 'Syne',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Username",
                      style: TextStyle(
                        color: Colors.black, // Black
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Syne',
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Your Name";
                        }
                        return null;
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Type your name here....",
                        prefixIcon: const Icon(Icons.person,
                            color: Colors.black), // Black
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              const BorderSide(color: Colors.black), // Black
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'LibreCaslonText',
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Password",
                      style: TextStyle(
                        color: Colors.black, // Black
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Syne',
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Your Password";
                        }
                        return null;
                      },
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.lock,
                            color: Colors.black), // Black
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Color(0xFF05A4C8)), // New blue shade
                        ),
                      ),
                      obscureText: true,
                      style: const TextStyle(
                        fontFamily: 'LibreCaslonText',
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    GestureDetector(
                      onTap: () {
                        loginAdmin();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF05A4C8),
                              Colors.white
                            ], // New blue to White
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 23.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Syne',
                            ),
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

  Future<void> loginAdmin() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("Admin").get();
      bool credentialsCorrect = false;

      for (var result in snapshot.docs) {
        var data = result.data() as Map<String, dynamic>?;

        if (data != null) {
          String? name = data['name'] as String?;
          String? password = data['password'] as String?;

          if (name != null && password != null) {
            if (name == nameController.text.trim() &&
                password == passwordController.text.trim()) {
              credentialsCorrect = true;
              await sharedPrefHelper.saveAdminData(name);

              // Show success popup
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor:
                        Colors.white, // Background color for the dialog
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_outline,
                            color: Color(0xFF05A4C8), size: 50),
                        const SizedBox(height: 20),
                        const Text(
                          "Login Successful",
                          style: TextStyle(
                            color: Color(0xFF05A4C8), // New blue shade
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WebMain()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color(0xFF05A4C8), // New blue shade
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text("Continue"),
                        ),
                      ],
                    ),
                  );
                },
              );
              break;
            }
          }
        }
      }

      if (!credentialsCorrect) {
        // Show error popup
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white, // Background color for the dialog
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 20),
                  const Text(
                    "Invalid Credentials",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red, // Red
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text("Try Again"),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
