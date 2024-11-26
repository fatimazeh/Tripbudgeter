import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future adduserdetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }


  Future<Stream<QuerySnapshot>> getUserDetails() async{
    return  FirebaseFirestore.instance.collection("users").snapshots();
  }

   Future updateEmployeeDetails(
     String id, Map<String, dynamic> updateInfo ) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(updateInfo);
  }

 Future DeleteUserDetails(String Id)async{
    return await FirebaseFirestore.instance
    .collection("users")
    .doc(Id)
    .delete();
  }

}
