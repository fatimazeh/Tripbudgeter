import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCityForm extends StatefulWidget {
  static const String id = "AddCityForm";
  @override
  _AddCityFormState createState() => _AddCityFormState();
}

class _AddCityFormState extends State<AddCityForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add city to Firestore
  Future<void> _addCity(String name, String province) async {
    try {
      await _firestore.collection('cities').add({
        'name': name,
        'province': province,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add city: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add City')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'City Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a city name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _provinceController,
                decoration: InputDecoration(labelText: 'Province'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a province';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addCity(_nameController.text, _provinceController.text);
                    _nameController.clear();
                    _provinceController.clear();
                  }
                },
                child: Text('Add City'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
