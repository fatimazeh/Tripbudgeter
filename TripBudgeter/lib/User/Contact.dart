import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('contacts').add({
          'name': _nameController.text,
          'email': _emailController.text,
          'message': _messageController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        _showDialog('Success', 'Contact message sent successfully!',
            Icons.check_circle, const Color(0xFF05a4c8));

        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      } catch (e) {
        _showDialog('Error', 'Failed to send message: ${e.toString()}',
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
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFdb5959),
                ),
              ),
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
          "Contact Us",
          style: GoogleFonts.libreCaslonText(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Change the title text color if needed
          ),
        ),
        backgroundColor: Color(0xFF05a4c8),
        automaticallyImplyLeading: false, // Set the AppBar background color
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
                        "If you have any questions or need assistance with the TripBudgeter app, feel free to reach out to us. Your satisfaction is our priority, and we value your input.",
                        style: GoogleFonts.libreCaslonText(
                          // Use your desired font here
                          fontSize: 16,

                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildTextField(
                          "Please enter your Name", _nameController),
                      const SizedBox(height: 20),
                      _buildTextField(
                          "Please enter your Email", _emailController),
                      const SizedBox(height: 20),
                      _buildTextField(
                        "Please enter your Message",
                        _messageController,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF05a4c8),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextButton(
                          onPressed: _submitForm,
                          child: const Text(
                            "SEND MESSAGE",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 70),
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

  Widget _buildTextField(String hint, TextEditingController controller,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $hint';
        }
        return null;
      },
    );
  }
}
