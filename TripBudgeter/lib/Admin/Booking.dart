import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency/User/Pages/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminBookingPage extends StatelessWidget {
  static const String id = "Booking";

  const AdminBookingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Booking View'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bookings').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No bookings found.'));
          }

          List<DocumentSnapshot> bookings = snapshot.data!.docs;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 16,
              columns: const [
                DataColumn(label: Text('Trip Name', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Destination', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Budget', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Start Date', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('End Date', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Traveler Name', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: bookings.map((booking) {
                String bookingId = booking.id;
                String tripName = booking['tripName'] ?? 'No Trip Name';
                String destination = booking['destination'] ?? 'No Destination';
                double budget = booking['budget'] ?? 0.0;
                String name = booking['Name'] ?? 'No Name';
                String email = booking['Email'] ?? 'No Email';
                String status = booking['status'] ?? 'No Status';

                Timestamp startDateTimestamp = booking['startDate'];
                Timestamp endDateTimestamp = booking['endDate'];
                DateTime startDate = startDateTimestamp.toDate();
                DateTime endDate = endDateTimestamp.toDate();
                String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
                String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

                return DataRow(cells: [
                  DataCell(Text(tripName)),
                  DataCell(Text(destination)),
                  DataCell(Text('\$${budget.toStringAsFixed(2)}')),
                  DataCell(Text(formattedStartDate)),
                  DataCell(Text(formattedEndDate)),
                  DataCell(Text(name)),
                  DataCell(Text(email)),
                  DataCell(Text(status)),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditDialog(context, bookingId, tripName, destination, budget, name, email, status);
                      },
                    ),
                  ),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  void _showEditDialog(
      BuildContext context,
      String bookingId,
      String tripName,
      String destination,
      double budget,
      String name,
      String email,
      String currentStatus) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController emailController = TextEditingController(text: email);

    List<String> statusOptions = ['Pending', 'Confirmed', 'Cancelled', 'In Progress'];

    String selectedStatus = statusOptions.contains(currentStatus) ? currentStatus : statusOptions.first;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Booking'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: statusOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newStatus) {
                    if (newStatus != null) {
                      selectedStatus = newStatus;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Get current logged-in user
                  final user = FirebaseAuth.instance.currentUser;

                  // Update booking status
                  await FirebaseFirestore.instance
                      .collection('bookings')
                      .doc(bookingId)
                      .update({
                    'Name': nameController.text,
                    'Email': emailController.text,
                    'status': selectedStatus,
                  });

                  // Add a notification with user's email and user ID
                  if (user != null) {
                    await FirebaseFirestore.instance
                        .collection('notifications')
                        .add({
                      'bookingId': bookingId,
                      'tripName': tripName,
                      'status': selectedStatus,
                      'Email': user.email, // Store the email of the current user
                      'userId': user.uid, // Store the ID of the current user
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                  }

                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update booking: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
