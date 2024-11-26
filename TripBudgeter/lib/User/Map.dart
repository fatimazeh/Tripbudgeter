import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CityFormPage(),
    );
  }
}

class City {
  final String name;
  final String location;
  final File image;

  City({required this.name, required this.location, required this.image});
}

class CityFormPage extends StatefulWidget {
  @override
  _CityFormPageState createState() => _CityFormPageState();
}

class _CityFormPageState extends State<CityFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  File? _image;
  List<City> _cities = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a City'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CityListPage(cities: _cities)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'City Name'),
            ),
            TextField(
              controller: _locationController,
              decoration:
                  InputDecoration(labelText: 'Location (latitude,longitude)'),
            ),
            SizedBox(height: 10),
            _image == null
                ? Text('No image selected.')
                : Image.file(_image!, height: 200),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick an Image'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addCity,
              child: Text('Add City'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _addCity() {
    if (_nameController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _image == null) {
      return; // Add validation message here
    }

    // Add city to the list
    setState(() {
      _cities.add(City(
        name: _nameController.text,
        location: _locationController.text,
        image: _image!,
      ));
    });

    // Clear input fields
    _nameController.clear();
    _locationController.clear();
    setState(() {
      _image = null;
    });
  }
}

extension on ImagePicker {
  getImage({required ImageSource source}) {}
}

class CityListPage extends StatelessWidget {
  final List<City> cities;

  CityListPage({required this.cities});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cities')),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];
          final latLng = city.location.split(',');
          final cityLocation =
              LatLng(double.parse(latLng[0]), double.parse(latLng[1]));

          return Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(city.name),
                  subtitle: Text(city.location),
                ),
                Image.file(city.image),
                SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: cityLocation, zoom: 12),
                    markers: {
                      Marker(
                          markerId: MarkerId(city.name),
                          position: cityLocation),
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
