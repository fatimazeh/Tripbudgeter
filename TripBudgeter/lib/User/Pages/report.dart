import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    // Get the current user
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Three tabs: Processing, Confirmed, Cancelled
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bookings Report'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Processing'),
              Tab(text: 'Confirmed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Processing Bookings Table
            BookingsTable(userId: user?.uid, status: 'In Progress'),
            // Confirmed Bookings Table
            BookingsTable(userId: user?.uid, status: 'Confirmed'),
            // Cancelled Bookings Table
            BookingsTable(userId: user?.uid, status: 'Cancelled'),
          ],
        ),
      ),
    );
  }
}

// Widget to display bookings in a table format
class BookingsTable extends StatelessWidget {
  final String? userId;
  final String status;

  BookingsTable({required this.userId, required this.status});

  @override
  Widget build(BuildContext context) {
    return userId == null
        ? Center(child: Text('User not logged in.'))
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('bookings') // Query the "bookings" collection
                .where('userId', isEqualTo: userId) // Filter by current user ID
                .where('status', isEqualTo: status) // Filter by booking status
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final bookings = snapshot.data!.docs;

              if (bookings.isEmpty) {
                return Center(
                  child: Text("No bookings with status: $status."),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal, // In case data table is wider
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Trip Name')),
                    DataColumn(label: Text('Destination')),
                    DataColumn(label: Text('Budget')),
                    DataColumn(label: Text('Start Date')),
                    DataColumn(label: Text('End Date')),
                  ],
                  rows: bookings.map((booking) {
                    final bookingData = booking.data() as Map<String, dynamic>;
                    return DataRow(cells: [
                      DataCell(Text(bookingData['tripName'] ?? '')),
                      DataCell(Text(bookingData['destination'] ?? '')),
                      DataCell(Text(bookingData['budget'].toString())),
                      DataCell(Text(DateFormat('yyyy-MM-dd')
                          .format(bookingData['startDate'].toDate()))),
                      DataCell(Text(DateFormat('yyyy-MM-dd')
                          .format(bookingData['endDate'].toDate()))),
                    ]);
                  }).toList(),
                ),
              );
            },
          );
  }
}
