import 'dart:async';

import 'package:currency/User/Contact.dart';
import 'package:currency/User/Feedback.dart';
import 'package:currency/User/Pages/Budget.dart';
import 'package:currency/User/Pages/notification.dart';
import 'package:currency/User/gallery.dart';
import 'package:currency/User/search.dart';
import 'package:flutter/material.dart';

class MadhangUI extends StatefulWidget {
  const MadhangUI({super.key});

  @override
  _MadhangUIState createState() => _MadhangUIState();
}

class _MadhangUIState extends State<MadhangUI> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  final int _pageCount = 3;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _pageCount - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section with search
            Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              padding: const EdgeInsets.only(right: 25.0, left: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  categoryGrid(context), // Category grid
                  const SizedBox(
                      height: 2), // Space between the grid and search bar
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchScreen()),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          bottom: 20.0), // Added margin bottom to the container
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            106, 163, 163, 163), // Fill color
                        borderRadius:
                            BorderRadius.circular(12.0), // Rounded corners
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0), // Padding for the text
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Color(0xFF05A4C8), // Icon color
                            ),
                            SizedBox(width: 10), // Space between icon and text
                            Text(
                              'Search Destination',
                              style: TextStyle(
                                color: Colors.black, // Text color
                                fontSize: 16.0, // Text size
                                fontWeight: FontWeight.bold, // Text weight
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Insert Explore Map UI here

                  const SizedBox(
                      height: 20), // Space between Explore and Promo section

                  // Promo section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 00.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Get inspired',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 0.0),
                          child: Text(
                            'Discover your next adventure',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 160,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                promoItem(
                                    'assets/get1.jfif',
                                    'Gudeg Blabak Tum',
                                    '1220 Dollar',
                                    const Color.fromARGB(255, 0, 0, 0)),
                                promoItem(
                                    'assets/get2.jfif',
                                    'Sate Ayam Pak Pono',
                                    '200 Dollar',
                                    const Color.fromARGB(255, 0, 0, 0)),
                                promoItem(
                                    'assets/get3.jfif',
                                    'Nasi Langgi Solo',
                                    '1000 Dollar',
                                    const Color.fromARGB(255, 0, 0, 0)),
                                promoItem(
                                    'assets/get4.jfif',
                                    'Gudeg Blabak Tum',
                                    '244 Dollar',
                                    const Color.fromARGB(255, 0, 0, 0)),
                                promoItem(
                                    'assets/get5.jfif',
                                    'Sate Ayam Pak Pono',
                                    '500 Dollar',
                                    const Color.fromARGB(255, 0, 0, 0)),
                                promoItem(
                                    'assets/get1.jfif',
                                    'Nasi Langgi Solo',
                                    '789 Dollar',
                                    const Color.fromARGB(255, 0, 0, 0)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Slider section
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Inspo incoming',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height:
                              200, // Ensure enough height to display the slider items
                          child: PageView(
                            controller: _pageController,
                            scrollDirection: Axis.horizontal,
                            children: [
                              SliderItem(
                                imageUrl: 'assets/slider1.jpg',
                                title: 'Just bring you',
                                description:
                                    'See where in the world to fly solo',
                              ),
                              SliderItem(
                                imageUrl: 'assets/slider2.webp',
                                title: 'Here you can enjoy everything',
                                description: 'Time to see the new world',
                              ),
                            ],
                          ),
                        ),

                        // Ask section
                        askSection(),
                      ],
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

  // Destination Card widget
  Widget DestinationCard({
    required String destination,
    required String price,
    required String imageUrl,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.network(
            imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {
                  // Favorite button action
                },
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Explore from Lahore section
  Widget exploreFromLahoreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Explore World',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            color: Colors.blueGrey.shade900,
            height: 350.0,
            width: double.infinity,
            child: Image.asset(
              '/logo/w.webp',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        Text(
          'See the world on your budget',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
            // Define your button action here
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: const Text(
            "Let's go",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget promoItem(
      String imageUrl, String title, String price, Color textColor) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.network(imageUrl,
                height: 100, width: 160, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 16, color: textColor)),
          Text(price, style: TextStyle(fontSize: 14, color: textColor)),
        ],
      ),
    );
  }

  // Slider item widget
  Widget SliderItem({
    required String imageUrl,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryGrid(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25.0), // Added margin top
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          categoryItem('assets/plane.png', 'Trips', context),
          categoryItem('assets/review.png', 'Feedback', context),
          categoryItem('assets/medical.png', 'Expense', context),
          categoryItem('assets/bell.png', 'Notification', context),
        ],
      ),
    );
  }

// Update the categoryItem widget
  Widget categoryItem(String imageUrl, String title, BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case 'Trips':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImageGalleryPage()),
            );
            break;
          case 'Feedback':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FeedbackForm()),
            );
            break;
          case 'Expense':
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Budgetscreen(
                        userData: {},
                      )),
            );
            break;
          case 'Notification':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationScreen()),
            );
            break;
        }
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(imageUrl,
                height: 50, width: 50, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.black)),
        ],
      ),
    );
  }

  // Ask section
  Widget askSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ask us anything',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            color: Colors.blueGrey.shade900,
            height: 350.0,
            width: double.infinity,
            child: Image.asset(
              'ask.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        Text(
          'Join us on Facebook for an AMA with our chief Scientist on September 18 at 1 PM ET',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContactPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: const Text(
            "Let's go",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
