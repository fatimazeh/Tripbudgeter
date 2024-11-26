import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisteredUsers extends StatefulWidget {
  static const String id = "RegisteredUser";
  @override
  _FetchUsersScreenState createState() => _FetchUsersScreenState();
}

class _FetchUsersScreenState extends State<RegisteredUsers> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registered Users"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No users found."));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index];
              final userName = userData['Name'];
              final userEmail = userData['Email'];

              return ListTile(
                title: Text(userName),
                subtitle: Text(userEmail),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deleteUser(userData.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("User deleted successfully")),
    );
  }
}
