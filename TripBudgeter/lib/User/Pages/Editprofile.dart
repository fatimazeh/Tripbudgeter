import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io' as io;

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;

  EditProfileScreen({required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  String? profileImageUrl; // For storing the image URL
  XFile? _imageFile; // To hold the selected image

  @override
  void initState() {
    super.initState();
    // Initialize text fields with user data
    nameController.text = widget.userData?['Name'] ?? '';
    emailController.text = widget.userData?['Email'] ?? '';
    ageController.text = widget.userData?['Age']?.toString() ?? '';
    addressController.text = widget.userData?['Address'] ?? '';
    genderController.text = widget.userData?['Gender'] ?? '';
    profileImageUrl =
        widget.userData?['Image'] ?? ''; // Get the current image URL
  }

  final ImagePicker _imagePicker = ImagePicker();

  // Pick a single image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });
      print("Image selected: ${_imageFile!.path}");
    } else {
      print("No image selected");
    }
  }

  // Upload the selected image to Firebase Storage and get the download URL
  Future<String> _uploadImage(XFile imageFile) async {
    Reference ref =
        FirebaseStorage.instance.ref().child("Images").child(imageFile.name);

    if (kIsWeb) {
      final data = await imageFile.readAsBytes();
      await ref.putData(data);
    } else {
      await ref.putFile(io.File(imageFile.path));
    }

    return await ref.getDownloadURL();
  }

  // Update the user data including the uploaded image URL
  Future<void> _updateUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print("Current user UID: ${user.uid}");

        if (_imageFile != null) {
          profileImageUrl =
              await _uploadImage(_imageFile!); // Upload the selected image
        }

        // Update Firestore with the user data
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .update({
          'Name': nameController.text,
          'Email': emailController.text,
          'Age': ageController.text, // Age stored as a string
          'Address': addressController.text,
          'Gender': genderController.text,
          'Image': profileImageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Profile updated successfully"),
        ));

        Navigator.pop(context); // Navigate back to the previous screen
      }
    } catch (e) {
      print("Error updating user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to update profile: $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display Profile Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: profileImageUrl != null && profileImageUrl!.isNotEmpty
                      ? Image.network(
                          profileImageUrl!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person,
                                size:
                                    100); // Fallback icon if image fails to load
                          },
                        )
                      : const Icon(Icons.person,
                          size: 100), // Fallback icon if no image is available
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage, // Button to pick the image
                child: const Text('Change Profile Picture'),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                readOnly: true, // Typically, email is not editable
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUserData,
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    color: Color(0xFF05a4c8),
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
