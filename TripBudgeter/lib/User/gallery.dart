import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:currency/User/detailtrip.dart';

class ImageGalleryPage extends StatelessWidget {
  static const String id = "ImageGalleryPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fetch images for the Carousel Slider from Firestore
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Tripss').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var trips = snapshot.data?.docs;

                if (trips == null || trips.isEmpty) {
                  return const Center(
                    child: Text('No images available for the carousel'),
                  );
                }

                // Fetching the first image of each trip for the carousel
                List<String> carouselImages = trips
                    .where((trip) =>
                        trip['images'] != null && trip['images'].isNotEmpty)
                    .map((trip) => trip['images'][0] as String)
                    .toList();

                return CarouselSlider(
                  options: CarouselOptions(
                    height: 250.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    autoPlayInterval: Duration(seconds: 3),
                  ),
                  items: carouselImages.map((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: NetworkImage(
                                  imageUrl), // Load Firestore images
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black
                                  .withOpacity(0.3), // Black with opacity
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(16.0), // Add padding
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Life is short and the world is wide',
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),

            SizedBox(height: 20), // Spacing between sections

            // Firestore GridView Section
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Tripss').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var trips = snapshot.data?.docs;

                  if (trips == null || trips.isEmpty) {
                    return const Center(
                      child: Text('No images available'),
                    );
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of images per row
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      var trip = trips[index];
                      var imageUrl = trip['images'] != null &&
                              trip['images'].isNotEmpty
                          ? trip['images'][0]
                          : 'https://via.placeholder.com/150'; // Placeholder if no image available

                      return GestureDetector(
                        onTap: () {
                          // Navigate to DetailPage with the specific trip document
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TripDetailPage(trip: trip),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
