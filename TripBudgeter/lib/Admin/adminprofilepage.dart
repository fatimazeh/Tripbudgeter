import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminProfilePage extends StatefulWidget {
  static const String id = "AdminProfilePage";

  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  Map<String, dynamic>? _adminData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchAdminInfo();
  }

  // Fetch the admin info from Firestore
  Future<void> _fetchAdminInfo() async {
    _user = _auth.currentUser;

    if (_user != null) {
      try {
        final adminSnapshot =
            await _firestore.collection('Admin').doc(_user!.uid).get();
        if (adminSnapshot.exists) {
          setState(() {
            _adminData = adminSnapshot.data();
            _loading = false;
          });
        } else {
          setState(() {
            _loading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Admin data not found.")),
          );
        }
      } catch (e) {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching admin data: $e")),
        );
      }
    } else {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not authenticated.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Profile'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _adminData != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name: ${_adminData!['name'] ?? 'N/A'}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Password: ${_adminData!['password'] ?? 'N/A'}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                )
              : Center(child: Text("No admin data available.")),
    );
  }
}
