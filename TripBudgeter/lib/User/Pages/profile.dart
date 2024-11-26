import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency/User/Pages/Budget.dart';
import 'package:currency/User/Pages/addTrip.dart';
import 'package:currency/User/Pages/report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Editprofile.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ProfileScreen({super.key, required this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserImage();
  }

  // Fetch image URL from Firestore
  Future<void> _fetchUserImage() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final uid = currentUser?.uid;

      if (uid != null) {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        var userData = userDoc.data() as Map<String, dynamic>;

        setState(() {
          imageUrl = userData['Image'] as String?;
        });
      }
    } catch (e) {
      print('Error fetching user image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = widget.userData;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF05a4c8),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Avatar with Image from Firestore
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: imageUrl != null && imageUrl!.isNotEmpty
                        ? Image.network(
                            imageUrl!,
                            width: 50, // Set a width for the image
                            height: 50, // Set a height for the image
                            fit: BoxFit
                                .cover, // Ensure the image fits within the bounds
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.person,
                                  size:
                                      50); // Fallback to an icon if image fails to load
                            },
                          )
                        : const Icon(Icons.person,
                            size:
                                50), // Fallback to an icon if no image is available
                  ),
                  const SizedBox(height: 10),
                  // Name and Email

                  const SizedBox(height: 5),

                  SizedBox(height: 20),
                  // Reward Points, Travel Trips, Bucket List Row
                ],
              ),
            ),
            SizedBox(height: 10),
            // Menu Items List
            _buildMenuItem(
              Icons.person_outline,
              'Profile',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileDetailsScreen()),
                );
              },
            ),
            _buildMenuItem(
              Icons.history,
              'Previous Trips',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PreviousTripsScreen()),
                );
              },
            ),
            _buildMenuItem(Icons.settings, 'Make My Trip', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewTripScreen()),
              );
            }),
            _buildMenuItem(Icons.report, 'Travel Details', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportScreen()),
              );
            }),
            _buildMenuItem(Icons.info_outline, 'Budget', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Budgetscreen(userData: userData)),
              );
            }),
          ],
        ),
      ),
    );
  }

  // Helper method to build stat columns
  Widget _buildStatColumn(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // Helper method to build menu items
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      iconColor: Color(0xFF05a4c8),
      title: Text(title),
      onTap: onTap,
    );
  }
}

// Helper method to build stat columns (Reward Points, Travel Trips, Bucket List)
Widget _buildStatColumn(String title, String count) {
  return Column(
    children: [
      Text(
        count,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
    ],
  );
}

// Helper method to build menu items
Widget _buildMenuItem(IconData icon, String title, Function onTap) {
  return ListTile(
    leading: Icon(icon, color: Colors.black),
    title: Text(title),
    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
    onTap: () => onTap(), // Call the provided function when tapped
  );
}

// Profile Details Screen

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  Map<String, dynamic>? userData;
  String? imageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print("Logged in as: ${user.uid}");
        String email = user.email!;
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("users")
            .where("Email", isEqualTo: email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot userDoc = querySnapshot.docs.first;
          userData = userDoc.data() as Map<String, dynamic>?;
          setState(() {
            imageUrl = userData?['Image'] as String?;
          });
        }
      }
    } catch (e) {
      // Handle error
      print("Error fetching user data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (userData != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditProfileScreen(userData: userData!),
                  ),
                ).then((_) => fetchUserData()); // Refresh data after edit
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData != null
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar with First Letter of Name
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: imageUrl != null && imageUrl!.isNotEmpty
                              ? Image.network(
                                  imageUrl!,
                                  width: 100, // Set a width for the image
                                  height: 100, // Set a height for the image
                                  fit: BoxFit
                                      .cover, // Ensure the image fits within the bounds
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.person,
                                        size:
                                            50); // Fallback to an icon if image fails to load
                                  },
                                )
                              : const Icon(Icons.person,
                                  size:
                                      50), // Fallback to an icon if no image is available
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "${userData!['Name'] ?? 'N/A'}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          " ${userData!['Email'] ?? 'N/A'}",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Display other profile fields here
                      _buildProfileField(
                        'Name',
                        " ${userData!['Name'] ?? 'N/A'}",
                      ),
                      _buildProfileField(
                        'Email',
                        " ${userData!['Email'] ?? 'N/A'}",
                      ),
                      _buildProfileField(
                        'Age',
                        " ${userData!['Age'] ?? 'N/A'}",
                      ),
                      _buildProfileField(
                        'Address',
                        " ${userData!['Address'] ?? 'N/A'}",
                      ),
                      _buildProfileField(
                        'Gender',
                        " ${userData!['Gender'] ?? 'N/A'}",
                      ),
                      // _buildProfileField('Bucket List', '473'),
                    ],
                  ),
                )
              : const Center(child: Text("No user data found")),
    );
  }

  // Helper method to build profile fields
  Widget _buildProfileField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

// New PreviousTripsScreen
class PreviousTripsScreen extends StatefulWidget {
  const PreviousTripsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PreviousTripsScreenState createState() => _PreviousTripsScreenState();
}

class _PreviousTripsScreenState extends State<PreviousTripsScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  // Function to show a dialog with all trip details
  void _showTripDetailsDialog(
      BuildContext context, Map<String, dynamic> tripData) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Trip Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${tripData['tripName'] ?? 'N/A'}'),
            Text('Destination: ${tripData['destination'] ?? 'N/A'}'),
            Text('Budget: ${tripData['budget']?.toString() ?? 'N/A'}'),
            Text(
                'Start Date: ${DateFormat('yyyy-MM-dd').format(tripData['startDate'].toDate())}'),
            Text(
                'End Date: ${DateFormat('yyyy-MM-dd').format(tripData['endDate'].toDate())}'),
            Text('Status: ${tripData['Status'] ?? 'N/A'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Trips'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: user == null
          ? const Center(child: Text('User not logged in.'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('New Trip')
                  .doc(user!.uid)
                  .collection('Trips') // Access the user's trips subcollection
                  .where('Status',
                      isEqualTo: 'Completed') // Fetch only completed trips
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final previousTrips = snapshot.data!.docs;

                if (previousTrips.isEmpty) {
                  return const Center(child: Text("No previous trips found."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: previousTrips.length,
                  itemBuilder: (context, index) {
                    final tripData =
                        previousTrips[index].data() as Map<String, dynamic>;

                    // Extract trip details
                    final tripName = tripData['tripName'] ?? 'Unnamed Trip';
                    final endDate = DateFormat('yyyy-MM-dd')
                        .format(tripData['endDate'].toDate());

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        title: Text(tripName),
                        subtitle: Text('End Date: $endDate'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Show a dialog with all the trip details
                          _showTripDetailsDialog(context, tripData);
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
