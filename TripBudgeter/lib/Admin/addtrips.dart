import 'dart:io';
import 'dart:io' as io;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class TripsPage extends StatefulWidget {
  static const String id = "TripPage";

  const TripsPage({super.key});

  @override
  _TripsPageState createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _personController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final imagepicker = ImagePicker();
  List<XFile> images = [];
  List<String> imageUrls = [];
  DateTime _startDate = DateTime.now();
  DateTime _endDate =
      DateTime.now().add(const Duration(days: 7)); // Default trip duration

  // Firestore reference
  final CollectionReference tripsCollection =
      FirebaseFirestore.instance.collection('Tripss');

  // Method to pick multiple images
  Future<void> pickImages() async {
    final List<XFile>? pickedImages = await imagepicker.pickMultiImage();
    if (pickedImages != null && pickedImages.isNotEmpty) {
      setState(() {
        images.addAll(pickedImages);
      });
    }
  }

  // Upload a single image to Firebase Storage
  Future<String> postImage(XFile imageFile) async {
    String downloadUrl;
    Reference ref =
        FirebaseStorage.instance.ref().child("Tripss").child(imageFile.name);

    if (kIsWeb) {
      await ref.putData(await imageFile.readAsBytes());
    } else {
      await ref.putFile(io.File(imageFile.path));
    }

    downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  // Upload all selected images and retrieve their URLs
  Future<void> uploadImages() async {
    for (var image in images) {
      String url = await postImage(image);
      imageUrls.add(url); // Add the URL to the list
    }
  }

  // Method to create a new trip and upload images
  Future<void> _createNewTrip() async {
    if (_formKey.currentState!.validate()) {
      // First upload all selected images
      await uploadImages();

      // Then add the new trip with image URLs to Firestore
      await tripsCollection.add({
        'tripName': _tripNameController.text,
        'destination': _destinationController.text,
        'budget': double.parse(_budgetController.text),
        'person': _personController.text,
        'description': _descriptionController.text,
        'images': imageUrls, // Store all image URLs
        'startDate': _startDate,
        'endDate': _endDate,
        'isCompleted': false,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New trip created successfully!')),
      );

      // Clear form and reset state
      _tripNameController.clear();
      _destinationController.clear();
      _budgetController.clear();
      _personController.clear();
      _descriptionController.clear();
      setState(() {
        images = [];
        imageUrls = [];
      });
    }
  }

  // Date picker
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trips'),
        backgroundColor: const Color(0xFF05a4c8),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF05a4c8), Colors.white],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _tripNameController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Trip Name',
                      labelStyle: const TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter trip name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _destinationController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Destination',
                      labelStyle: const TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter destination';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _budgetController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Budget',
                      labelStyle: const TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter budget';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _personController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Person Involved',
                      labelStyle: const TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the person involved in the trip';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Trip Description',
                      labelStyle: const TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Image Picker Section
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            if (images.isNotEmpty)
                              SizedBox(
                                height: 150.0,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: images.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: kIsWeb
                                          ? FutureBuilder<Uint8List>(
                                              future:
                                                  images[index].readAsBytes(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  return Image.memory(
                                                    snapshot.data!,
                                                    fit: BoxFit.cover,
                                                    width: 150,
                                                  );
                                                } else {
                                                  return const CircularProgressIndicator();
                                                }
                                              },
                                            )
                                          : Image.file(
                                              File(images[index].path),
                                              fit: BoxFit.cover,
                                              width: 150,
                                            ),
                                    );
                                  },
                                ),
                              )
                            else
                              Container(
                                height: 150.0,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Text('No Images Selected'),
                                ),
                              ),
                            ElevatedButton(
                              onPressed: pickImages,
                              child: const Text('Pick Images'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Date pickers
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          DateFormat.yMd().format(_startDate),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today,
                            color: Colors.black),
                        onPressed: () => _selectDate(context, true),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          DateFormat.yMd().format(_endDate),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today,
                            color: Colors.black),
                        onPressed: () => _selectDate(context, false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF05a4c8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: _createNewTrip,
                      child: const Text('Create Trip'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Active Trips Section
            const Text(
              'Active Trips',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: tripsCollection
                  .where('isCompleted', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text('No active trips',
                      style: TextStyle(color: Colors.black));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    var trip = snapshot.data?.docs[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        leading: trip?['images'] != null &&
                                trip?['images'].isNotEmpty
                            ? Image.network(trip?['images'][0],
                                width: 50, height: 50, fit: BoxFit.cover)
                            : const Icon(Icons.image, size: 50),
                        title: Text(
                          trip?['tripName'] ?? '',
                          style: const TextStyle(color: Colors.black),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Destination: ${trip?['destination']}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            Text(
                              'Person: ${trip?['person']}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            Text(
                              'Description: ${trip?['description']}',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        trailing: Text(
                          'Budget: \$${trip?['budget']}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
