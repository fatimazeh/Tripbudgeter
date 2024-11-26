import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore
import 'package:firebase_auth/firebase_auth.dart'; // For FirebaseAuth
import 'package:flutter_typeahead/flutter_typeahead.dart';

class NewTripScreen extends StatefulWidget {
  static const String id = "NewTripScreen";

  @override
  _NewTripScreenState createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _tripNameController = TextEditingController();
  TextEditingController _fromController = TextEditingController(); // From City
  TextEditingController _toController = TextEditingController(); // To City
  TextEditingController _personController = TextEditingController(); // Number of persons

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isRoundTrip = false; // Logical field for round trip

  // Function to pick a date
  Future<void> _pickDate({required bool isStartDate}) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = selectedDate;
        } else {
          _endDate = selectedDate;
        }
      });
    }
  }

  // Function to fetch cities from Firestore and filter based on the search query
  Future<List<String>> _fetchCities(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('cities')
        .where('name', isGreaterThanOrEqualTo: query)
        .limit(10)
        .get();
    
    return result.docs.map((doc) => doc['name'].toString()).toList();
  }

  // Function to submit the form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _endDate == null) {
        // Show an alert if the user didn't select dates
        _showDialog('Error', 'Please select both start and end dates.');
      } else if (_startDate!.isAfter(_endDate!)) {
        // Show an alert if the start date is after the end date
        _showDialog('Error', 'Start date cannot be after end date.');
      } else {
        try {
          // Get the current user
          User? user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            // Save the data to Firestore
            await FirebaseFirestore.instance
                .collection('New Trips')
                .doc(user.uid)
                .collection('Trips')
                .add({
              'tripName': _tripNameController.text,
              'from': _fromController.text,
              'to': _toController.text,
              'startDate': _startDate,
              'endDate': _endDate,
              'persons': int.parse(_personController.text), // Number of persons
              'isRoundTrip': _isRoundTrip, // Logical field for round trip
              'status': 'Soon', // Default status
              'userId': user.uid,  // User ID
              'createdBy': user.email, // User email
            });

            // Show success dialog
            _showDialog(
              'Success',
              'Trip Created Successfully!\n\n'
                  'Trip Name: ${_tripNameController.text}\n'
                  'From: ${_fromController.text}\n'
                  'To: ${_toController.text}\n'
                  'Persons: ${_personController.text}\n'
                  'Round Trip: ${_isRoundTrip ? "Yes" : "No"}\n'
                  'Dates: ${DateFormat('yyyy-MM-dd').format(_startDate!)} to ${DateFormat('yyyy-MM-dd').format(_endDate!)}',
            );
          } else {
            _showDialog('Error', 'User is not authenticated. Please log in.');
          }
        } catch (e) {
          _showDialog('Error', 'Failed to create trip: ${e.toString()}');
        }
      }
    }
  }

  // Function to show dialog alerts
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Trip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Trip Name
              TextFormField(
                controller: _tripNameController,
                decoration: const InputDecoration(
                  labelText: 'Trip Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a trip name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // From (City Search Field)
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _fromController,
                  decoration: const InputDecoration(
                    labelText: 'From',
                    border: OutlineInputBorder(),
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return _fetchCities(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _fromController.text = suggestion;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // To (City Search Field)
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _toController,
                  decoration: const InputDecoration(
                    labelText: 'To',
                    border: OutlineInputBorder(),
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return _fetchCities(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _toController.text = suggestion;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Dates (Start and End Date Pickers)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _pickDate(isStartDate: true),
                      child: Text(_startDate != null
                          ? 'Start: ${DateFormat('yyyy-MM-dd').format(_startDate!)}'
                          : 'Pick Start Date'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _pickDate(isStartDate: false),
                      child: Text(_endDate != null
                          ? 'End: ${DateFormat('yyyy-MM-dd').format(_endDate!)}'
                          : 'Pick End Date'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Number of Persons
              TextFormField(
                controller: _personController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of Persons',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of persons';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Round Trip Checkbox
              CheckboxListTile(
                title: const Text("Round Trip"),
                value: _isRoundTrip,
                onChanged: (bool? value) {
                  setState(() {
                    _isRoundTrip = value!;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Create Trip'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
