import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  Future<void> saveAdminData(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('adminName', name);

    print("Admin data saved: $name");
  }

  Future<String?> getAdminData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('adminName');

    print("Admin data fetched: $name");
    return name;
  }

  Future<void> clearAdminData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('adminName');
  }

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<Map<String, dynamic>?> getContactDetails(String id) async {
    try {
      final doc = await _firestore.collection('UserContact').doc(id).get();
      if (doc.exists) {
        return doc.data();
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching contact details: $e');
      return null;
    }
  }


}
