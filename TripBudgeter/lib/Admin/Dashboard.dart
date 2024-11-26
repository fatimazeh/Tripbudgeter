
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import the AdminProfilePage

class AdminDashboard extends StatelessWidget {
  static const String id = "AdminDashboard";

  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
    
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 1000
              ? 4
              : constraints.maxWidth > 800
                  ? 3
                  : constraints.maxWidth > 600
                      ? 2
                      : 1;

          double cardAspectRatio = constraints.maxWidth > 600 ? 2 : 1.5;

          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: crossAxisCount,
                childAspectRatio: cardAspectRatio,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Total Users Count
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _StatCard(
                          title: 'Total Users',
                          value: 'Loading...',
                          color: Color(0xFF05A4C8),
                        );
                      }
                      if (!snapshot.hasData) {
                        return _StatCard(
                          title: 'Total Users',
                          value: 'Error',
                          color: Color(0xFF05A4C8),
                        );
                      }
                      final int totalUsers = snapshot.data!.docs.length;
                      return _StatCard(
                        title: 'Total Users',
                        value: totalUsers.toString(),
                        color: Color(0xFF05A4C8),
                      );
                    },
                  ),
                  // Total Feedback Count
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('feedbacks')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _StatCard(
                          title: 'Total Feedback',
                          value: 'Loading...',
                          color: Color(0xFF05A4C8),
                        );
                      }
                      if (!snapshot.hasData) {
                        return _StatCard(
                          title: 'Total Feedback',
                          value: 'Error',
                          color: Color(0xFF05A4C8),
                        );
                      }
                      final int totalFeedbacks = snapshot.data!.docs.length;
                      return _StatCard(
                        title: 'Total Feedback',
                        value: totalFeedbacks.toString(),
                        color: Color(0xFF05A4C8),
                      );
                    },
                  ),
                  // Total Contact Messages Count
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('contacts')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _StatCard(
                          title: 'Contact Messages',
                          value: 'Loading...',
                          color: Color(0xFF05A4C8),
                        );
                      }
                      if (!snapshot.hasData) {
                        return _StatCard(
                          title: 'Contact Messages',
                          value: 'Error',
                          color: Color(0xFF05A4C8),
                        );
                      }
                      final int totalContacts = snapshot.data!.docs.length;
                      return _StatCard(
                        title: 'Contact Messages',
                        value: totalContacts.toString(),
                        color: Color(0xFF05A4C8),
                      );
                    },
                  ),
                  _StatCard(
                      title: 'Total Trip',
                      value: '100',
                      color: Color(0xFF05A4C8)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSizeTitle = screenWidth > 600 ? 20 : 16;
    double fontSizeValue = screenWidth > 600 ? 28 : 24;
    double padding = screenWidth > 600 ? 20.0 : 12.0;

    return Container(
      width: 200,
      height: 100,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSizeValue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
