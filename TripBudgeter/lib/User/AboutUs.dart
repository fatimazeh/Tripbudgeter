import 'package:currency/main.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            '../assets/1.jpg', // Replace with your background image path
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Center(
            child: Container(
              width: 375, // Approximate width of a mobile screen
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9), // Semi-transparent background
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        '../assets/Logo/Budgeterbanner_logo.jpg', // Replace with your logo image path
                        height: 30,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'About Us.',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "We're on a mission to add relevancy to every online experience.",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LayoutScreen()), // Replace HomePage with your home page widget
    );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blue,
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('Back to Home'),
                    ),
                    const SizedBox(height: 32),
                    
                    // Horizontal Slider Section
              
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [

                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                    const Text(
                      'Our Purpose',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Many brands are using personalization to build better customer journeys, but we believe it takes more than personalization to build truly unforgettable digital experiences. That's why we're committed to delivering relevancy.",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to create a promo item
  Widget promoItem(String imagePath, String title, String price) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              imagePath,
              height: 120,
              width: 180,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
