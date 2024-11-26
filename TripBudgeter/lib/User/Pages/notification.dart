import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String email = user.email!;
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("notifications")
            .where("Email", isEqualTo: email)
            .get();

        notifications = querySnapshot.docs.map((doc) {
          return {
            'id': doc.id, // Store the document ID for deletion
            'tripName': doc['tripName'],
            'status': doc['status'],
            'timestamp': doc['timestamp'],
          };
        }).toList();
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> showDeleteDialog(String notificationId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Notification'),
          content: Text('Are you sure you want to delete this notification?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cancel
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await deleteNotification(notificationId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationId)
          .delete();
      // Update the local state after deletion
      setState(() {
        notifications.removeWhere(
            (notification) => notification['id'] == notificationId);
      });
    } catch (e) {
      print("Error deleting notification: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding:
                    const EdgeInsets.only(top: 40), // Adjust the top padding
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : notifications.isEmpty
                        ? Center(
                            child: Text(
                              'No notifications.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              final notification = notifications[index];
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xFFEFEFEF),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 8,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.notifications,
                                      color: Color(0xFF05a4c8)),
                                  title: Text(
                                    notification['tripName'] ?? 'No Title',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "Status: ${notification['status'] ?? 'No Message'}",
                                  ),
                                  trailing: Text(
                                    (notification['timestamp'] as Timestamp)
                                        .toDate()
                                        .toString(),
                                  ),
                                  onTap: () =>
                                      showDeleteDialog(notification['id']),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
