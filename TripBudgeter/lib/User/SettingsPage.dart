import 'package:currency/User/AboutUs.dart';
import 'package:currency/User/Contact.dart';
import 'package:currency/User/Feedback.dart';
import 'package:flutter/material.dart';

class HubPage extends StatelessWidget {
  const HubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Contact Us'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ContactPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Feedback'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => FeedbackForm()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AboutUs()),
              );
            },
          ),
        ],
      ),
    );
  }
}
