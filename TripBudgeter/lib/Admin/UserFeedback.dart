import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FetchFeedbackPage extends StatefulWidget {
  static const String id = "FeedbackPage";
  @override
  _FetchFeedbackPageState createState() => _FetchFeedbackPageState();
}

class _FetchFeedbackPageState extends State<FetchFeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('feedbacks')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No feedback found."));
          }

          final feedbacks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              var feedback = feedbacks[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(feedback['name'] ?? "Anonymous"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(feedback['email'] ?? "No email provided"),
                      SizedBox(height: 4),
                      Text(feedback['feedback'] ?? "No feedback provided"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
