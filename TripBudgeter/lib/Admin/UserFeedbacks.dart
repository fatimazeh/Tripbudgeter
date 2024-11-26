import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackListPage extends StatelessWidget {
  static const String id = "FeedbackListPage";
  const FeedbackListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feedback List',
          style: GoogleFonts.libreCaslonText(color: Colors.white), // Light Pink
        ),

        backgroundColor: const Color(0xFF597CFF), // Blue
        elevation: 0, // Remove shadow for a cleaner look
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [ Colors.white, Colors.white,Color(0xFF597CFF),], // Gradient colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('feedback').orderBy('timestamp', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No feedback available.'));
              }

              final feedbackDocs = snapshot.data!.docs;

              return ListView.builder(
                itemCount: feedbackDocs.length,
                itemBuilder: (context, index) {
                  final feedbackData = feedbackDocs[index].data() as Map<String, dynamic>;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Light Brown
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feedbackData['name'] ?? 'No Name',
                              style: GoogleFonts.libreCaslonText(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF597CFF), // Dark Blue
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              feedbackData['email'] ?? 'No Email',
                              style: GoogleFonts.libreCaslonText(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              feedbackData['feedback'] ?? 'No Feedback',
                              style: GoogleFonts.libreCaslonText(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Submitted on: ${feedbackData['timestamp'].toDate()}',
                              style: GoogleFonts.libreCaslonText(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
