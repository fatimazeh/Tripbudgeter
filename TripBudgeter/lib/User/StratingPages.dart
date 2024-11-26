
import 'package:currency/User/AboutUs.dart';
import 'package:currency/User/Auth/Signup_page.dart';
import 'package:currency/User/Auth/sigin_page.dart';
import 'package:currency/User/Contact.dart';

import 'package:currency/User/Feedback.dart';
import 'package:currency/User/gallery.dart';

import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class LiquidSwipeScreen extends StatefulWidget {
  @override
  _LiquidSwipeScreenState createState() => _LiquidSwipeScreenState();
}

class _LiquidSwipeScreenState extends State<LiquidSwipeScreen> {
  final LiquidController _liquidController = LiquidController();
  int currentPage = 0;

  final pages = [
    // First page
    Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Image(
            image: AssetImage('assets/1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.4),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Life is short and the world is wide",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "At Friends tours and travels, we customize reliable and trustworthy educational tours to destinations all over the world.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    // Second page
    Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Image(
            image: AssetImage('assets/4.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.4),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "It’s a big world out there go explore",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "To get the best of your adventure you just need to leave and go where we lead.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    // Third page with swipe navigation
    Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Image(
            image: AssetImage('assets/2.webp'),
            fit: BoxFit.cover,
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.4),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "People don’t take trips, trips take people",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Swipe left to navigate to the next screen.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            LiquidSwipe(
              pages: pages,
              liquidController: _liquidController,
              onPageChangeCallback: onPageChangeCallback,
              enableLoop: false,
              waveType: WaveType.liquidReveal,
            ),
            Positioned(
              bottom: 70, // Adjust to position the text correctly
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(pages.length, buildDot),
                  ),
                  SizedBox(height: 10), // Space between dots and text
                  if (currentPage <
                      pages.length - 1) // Only show for non-last pages
                    Text(
                      "Swipe left to navigate",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onPageChangeCallback(int page) {
    setState(() {
      currentPage = page;
    });

    if (page == pages.length - 1) {
      Future.delayed(Duration(milliseconds: 300), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>LoginPage()),
        );
      });
    }
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: currentPage == index ? 12 : 8,
      height: currentPage == index ? 12 : 8,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.white : Colors.white54,
        shape: BoxShape.circle,
      ),
    );
  }
}
