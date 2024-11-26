import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class TripsListScreen extends StatelessWidget {
  static const String id = "TripsListScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _fetchTrips(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No trips found.'));
          }

          // Display trips in a ListView
          final trips = snapshot.data!.docs;

          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              var trip = trips[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(trip['tripName']),
                  subtitle: Text(
                    'From: ${trip['from']}\nTo: ${trip['to']}\n'
                    'Dates: ${DateFormat('yyyy-MM-dd').format(trip['startDate'].toDate())} to '
                    '${DateFormat('yyyy-MM-dd').format(trip['endDate'].toDate())}\n'
                    'Persons: ${trip['persons']}\n'
                    'Round Trip: ${trip['isRoundTrip'] ? "Yes" : "No"}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Function to fetch trips from Firestore
  Future<QuerySnapshot> _fetchTrips() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return await FirebaseFirestore.instance
          .collection('New Trips')
          .doc(user.uid)
          .collection('Trips')
          .get();
    } else {
      throw Exception("User not authenticated");
    }
  }
}
