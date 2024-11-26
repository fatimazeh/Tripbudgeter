import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static const String userNameKey = "User_Name";
  static const String userEmailKey = "User_Email";
  static const String userImageKey = "User_Image";
  static const String userIdKey = "User_Id";
  static const String userContactKey = "User_Contact";
  static const String userAdressKey = "User_Address";


// Maethed for get svae (user id,user name,user email, user image and use in after login )

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserImage(String getUserImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userImageKey, getUserImage);
  }

  Future<bool> saveUserContact(String getUserContact)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userContactKey, getUserContact);
  }

  Future<bool> saveUserAddress(String getUserAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userAdressKey, getUserAddress);
  }




  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }
  Future<String?> getUserContact() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userContactKey);
  }
  
  Future<String?> getUserAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userAdressKey);
  }

  Future<String?> getUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userImageKey);
  }


  Future<String?> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(userNameKey);
    await prefs.remove(userImageKey);
    await prefs.remove(userEmailKey);
    await prefs.remove(userContactKey);
    await prefs.remove(userAdressKey);
  
    return null;
  }
}
