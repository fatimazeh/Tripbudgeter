import 'package:flutter/material.dart';
import 'package:currency/Admin/AdminLogin.dart';

class SpaceExploringPage extends StatelessWidget {
  const SpaceExploringPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side with image and rounded corners
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      '../assets/slider2.webp'), // Add your background image path
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(70),
                  bottomLeft: Radius.circular(70),
                ),
              ),
            ),
          ),
          // Right side with text content and rounded corners
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(32.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF05a4c8),
                    Color(0xFF05a4c8), // Your first gradient color
                    Colors.white // Your second gradient color
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome to Travel Budgeter Admin Panel',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Manage users, trips, expenses, and maintain the overall system for seamless operations. Our intuitive dashboard provides a bird's-eye view of app activity, user insights, and system health to help you oversee every aspect of the platform efficiently.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40), // Adjusted space for the button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(
                          255, 183, 127, 127), // Button background
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminLogin()),
                      );
                    },
                    child: const Text(
                      'Go to Admin Login',
                      style: TextStyle(
                        color: Colors.white, // Button text color
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
