import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  double amount = 0.0;
  String category = '';
  String note = '';
  String date = 'Today';

  Future<void> _saveExpense() async {
    try {
      User? user = _auth.currentUser; // Get the current user
      if (user != null) {
        // Create a document in the 'Expenses' collection for the current user
        await _firestore.collection('Add Budgets').doc(user.uid).collection('Budgets').add({
          'userId': user.uid,         // Associate expense with the current user
          'amount': amount,
          'category': category,
          'note': note,
          'date': date,
          'createdAt': FieldValue.serverTimestamp(),  // Store timestamp
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Expense added successfully!')),
        );

        // Clear the form
        setState(() {
          amount = 0.0;
          category = '';
          note = '';
          date = 'Today';
        });

        Navigator.pop(context);
      } else {
        // If user is not signed in, show an error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not signed in!')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add expense!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Add Expenses',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Amount Input Field
              TextFormField(
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: '\$0',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
                onChanged: (value) {
                  setState(() {
                    amount = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              Divider(),

              // Category Input Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    category = value;
                  });
                },
              ),
              SizedBox(height: 20),

              // Note Input Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Note',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    note = value;
                  });
                },
              ),
              SizedBox(height: 20),

              // Date Input Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Today',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      date = "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
              ),
              SizedBox(height: 30),

              // Save Button
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _saveExpense();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blueAccent, Colors.purpleAccent],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'SAVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
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
}
