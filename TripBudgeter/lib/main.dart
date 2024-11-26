import 'package:currency/Admin/ViewExpense.dart';
import 'package:currency/LayoutScreen.dart';
import 'package:currency/User/Auth/sigin_page.dart';
import 'package:currency/User/Contact.dart';
import 'package:currency/User/GetTrips.dart';

import 'package:currency/User/Home.dart';
import 'package:currency/User/Pages/notification.dart';

import 'package:currency/User/Pages/profile.dart';
import 'package:currency/User/SettingsPage.dart';

import 'package:currency/User/Map.dart';
import 'package:currency/User/StratingPages.dart';
import 'package:currency/User/gallery.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCQ-yekfmusLC2CiXVrGTBSSSyGev39WjY",
          authDomain: "tripbudgeter-20771.firebaseapp.com",
          projectId: "tripbudgeter-20771",
          storageBucket: "tripbudgeter-20771.appspot.com",
          messagingSenderId: "982227848014",
          appId: "1:982227848014:web:5796b809b851252dc6ec1f",
          measurementId: "G-14SN26F38C"),
    );
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCQ-yekfmusLC2CiXVrGTBSSSyGev39WjY",
            authDomain: "tripbudgeter-20771.firebaseapp.com",
            projectId: "tripbudgeter-20771",
            storageBucket: "tripbudgeter-20771.appspot.com",
            messagingSenderId: "982227848014",
            appId: "1:982227848014:web:5796b809b851252dc6ec1f",
            measurementId: "G-14SN26F38C"));
  }

  runApp(const MyApp());
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LiquidSwipeScreen()),
      );
    });
  }

// LiquidSwipeScreen()
// LiquidSwipeScreen()
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              '../assets/Logo/SplashScreenLogo.gif',
              width: 400,
              height: 400,
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trip Budgeter',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Syne',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF597CFF),
          titleTextStyle: TextStyle(
            fontFamily: 'Parisienne',
            fontSize: 25,
          ),
        ),
        // iconTheme: const IconThemeData(
        //   color: Colors.black,
        // ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            selectedItemColor: Color(0xFF05a4c8),
            unselectedItemColor: Colors.black),
      ),
      home: const Layoutscreen(),
    );
  }
}

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  _LayoutScreenState createState() => _LayoutScreenState();
}

class LayoutScreenState extends StatefulWidget {
  const LayoutScreenState({super.key});

  @override
  _LayoutScreenState createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MadhangUI(),
    ContactPage(),
    const NotificationScreen(),
    ImageGalleryPage(),
    const HubPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              "TRIP BUDGETER",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05a4c8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications,
                color: Color(0xFF05a4c8)), // Notification icon
            onPressed: () {
              setState(() {
                _currentIndex = 2; // Navigate to Notifications page
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Color(0xFF05a4c8)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(userData: {}),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout,
                color: Color(0xFF05a4c8)), // Logout icon
            onPressed: () {
              // Navigate to LoginPage
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.home, 0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.contact_emergency, 1),
            label: 'Contact',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.notification_add, 2),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.image, 3),
            label: 'Gallery',
          ),
        ],
        selectedItemColor: const Color(0xFF05a4c8),
        unselectedItemColor: const Color.fromARGB(255, 122, 106, 106),
        backgroundColor:
            Colors.white, // White background for the bottom navigation
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    return Icon(
      icon,
      color: _currentIndex == index
          ? Colors.black // Selected icon color
          : Color(0xFF05a4c8), // Unselected icon color
      size: 24,
    );
  }
}
