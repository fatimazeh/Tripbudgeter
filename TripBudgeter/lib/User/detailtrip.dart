import 'package:currency/User/checkout.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // To format date

class TripDetailPage extends StatelessWidget {
  final QueryDocumentSnapshot trip;

  const TripDetailPage({Key? key, required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tripName = trip['tripName'] ?? 'No Trip Name';
    var destination = trip['destination'] ?? 'No Destination';
    var budget = trip['budget'] ?? 0.0;
    var person = trip['person'] ?? 'No Person';
    var description = trip['description'] ?? 'No Description';
    var imageUrls = trip['images'] != null && trip['images'].isNotEmpty
        ? trip['images']
        : [
            'https://via.placeholder.com/150'
          ]; // Placeholder if no images are available

    // Use the first image as the background
    var backgroundImageUrl = imageUrls[0];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Allow back navigation
        title: Row(
          children: [
            Text(
              "Trip Budgeter",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFdb5959),
              ),
            ),
          ],
        ),
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Color(0xFF05A4C8)),
            onPressed: () {
              // Navigate to profile screen
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image with Black Opacity
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(backgroundImageUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black
                      .withOpacity(0.6), // Black overlay with 60% opacity
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // Main Content (Container with no border and larger padding)
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color:
                        Colors.white.withOpacity(0.1), // Transparent background
                  ),
                  padding: const EdgeInsets.all(24.0), // Increased padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Trip Name and Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tripName,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '\$$budget',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF05A4C8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Destination
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Color(0xFF05A4C8)),
                          const SizedBox(width: 5),
                          Text(
                            destination,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Description
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      const SizedBox(height: 24),

                      // Book Now Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(trip: trip),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF05A4C8),
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Book Now',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
