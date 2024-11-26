import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('feedbacks').add({
          'name': _nameController.text,
          'email': _emailController.text,
          'feedback': _feedbackController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        _showDialog('Success', 'Feedback submitted successfully!',
            Icons.check_circle, const Color(0xFF05a4c8));

        _nameController.clear();
        _emailController.clear();
        _feedbackController.clear();
      } catch (e) {
        _showDialog('Error', 'Failed to submit feedback: ${e.toString()}',
            Icons.error, Colors.red);
      }
    }
  }

  void _showDialog(
      String title, String message, IconData icon, Color iconColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LayoutScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feedback',
          style: GoogleFonts.libreCaslonText(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF05a4c8),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LayoutScreen()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
               Color(0xFF05a4c8),
                Color(0xFFdb5959),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "We Value Your Feedback",
                        style: GoogleFonts.libreCaslonText(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Your feedback helps us improve our services. Please let us know your thoughts, suggestions, or any issues you encountered.",
                        style: GoogleFonts.libreCaslonText(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildTextField("Name", _nameController),
                      const SizedBox(height: 20),
                      _buildTextField("Email", _emailController),
                      const SizedBox(height: 20),
                      _buildTextField(
                        "Feedback",
                        _feedbackController,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF05a4c8),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextButton(
                          onPressed: _submitFeedback,
                          child: const Text(
                            "Submit Feedback",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 130),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 10,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    gradient: const LinearGradient(
                      colors: [

Colors.white,
                        Color(0xFF05a4c8),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 100,
                right: 50,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.white,
                   Color(0xFF05a4c8),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
