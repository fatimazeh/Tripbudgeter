import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'detailtrip.dart'; // Assuming detailtrip.dart contains the TripDetailPage

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Stream<QuerySnapshot>? tripStream;
  final TextEditingController destinationController = TextEditingController();
  String searchTerm = '';

  // Function to fetch suggestions from Firestore based on input
  Future<List<String>> _fetchSuggestions(String pattern) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Tripss')
        .where('destination', isGreaterThanOrEqualTo: pattern)
        .where('destination', isLessThanOrEqualTo: pattern + '\uf8ff')
        .get();

    return querySnapshot.docs
        .map((doc) => doc['destination'] as String)
        .toList();
  }

  void _updateStream(String selectedDestination) {
    setState(() {
      searchTerm = selectedDestination;
      var query = FirebaseFirestore.instance
          .collection('Tripss')
          .where('destination', isEqualTo: searchTerm);
      tripStream = query.snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Trips"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Search Destinations",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue),
            ),
            const SizedBox(height: 15),

            // TypeAheadField for Auto-complete Suggestions
            TypeAheadField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: destinationController,
                decoration: InputDecoration(
                  hintText: "Enter destination",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.lightBlue),
                ),
              ),
              suggestionsCallback: (pattern) async {
                return _fetchSuggestions(
                    pattern); // Fetch suggestions from Firestore
              },
              itemBuilder: (context, String suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (String suggestion) {
                // Update the stream when a suggestion is selected
                _updateStream(suggestion);
              },
            ),

            const SizedBox(height: 15),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: tripStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No trips found.'));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot ds =
                          snapshot.data!.docs[index] as QueryDocumentSnapshot;

                      // Get image URL safely, with a fallback default image
                      String imageUrl = (ds.get('images') is List &&
                              (ds.get('images') as List).isNotEmpty)
                          ? (ds.get('images') as List).first as String
                          : 'https://via.placeholder.com/150'; // Default image

                      // Get date and description safely with fallback values
                      String startDate = ds.get('startDate') != null
                          ? (ds.get('startDate') as Timestamp)
                              .toDate()
                              .toLocal()
                              .toString()
                              .split(' ')[0]
                          : 'No date';

                      String description =
                          ds.get('description') ?? 'No description';

                      return GestureDetector(
                        onTap: () {
                          // Navigate to the TripDetailPage with the selected trip data
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TripDetailPage(
                                  trip: ds), // Pass the document snapshot
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15)),
                                child: Container(
                                  height: 220,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Destination: ${ds.get('destination')}",
                                      style: const TextStyle(
                                        color: Colors.lightBlue,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Date: $startDate",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Details: $description",
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
