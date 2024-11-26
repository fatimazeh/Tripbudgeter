import 'package:currency/User/Auth/sigin_page.dart';
import 'package:currency/services/data.dart';
import 'package:currency/text_file_model/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? name, mail, password, age, gender, address;

  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  registration() async {
    if (name != null && mail != null && password != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: mail!, password: password!);

        String uid = userCredential.user!.uid;

        Map<String, dynamic> userInfoMap = {
          "id": uid,
          "Name": name,
          "Email": mail,
          "Age": age,
          "Address": address,
          "Gender": gender,
          "Image": "https://img.freepik.com/free-vector/cute-detective-bear-cartoon-character_138676-2911.jpg?t=st=1724242859~exp=1724246459~hmac=8f34071c2563d58b6dc7a3ea9c5504d9e3043f10141a5ceef5412a8826f3ab64&w=740",
        };

        await DatabaseMethods().adduserdetails(userInfoMap, uid);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xFF05a4c8),
          content: const Text("Registered Successfully", style: TextStyle(fontSize: 20, color: Colors.white)),
        ));

        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
      } on FirebaseAuthException catch (e) {
        // Handle errors as before...
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF05a4c8),
                Color.fromARGB(255, 183, 127, 127),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView( // Add this
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          "Create an account to continue",
                          style: TextStyle(fontSize: 16, color: Colors.white54),
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildTextField("Enter Username", userController),
                      const SizedBox(height: 20),
                      _buildTextField("Enter Email", emailController),
                      const SizedBox(height: 20),
                      _buildTextField("Enter Age", ageController),
                      const SizedBox(height: 20),
                      _buildTextField("Enter Gender", genderController),
                      const SizedBox(height: 20),
                      _buildTextField("Enter Address", addressController),
                      const SizedBox(height: 20),
                      _buildTextField("Enter Password", passwordController, obscureText: true),
                      const SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF05a4c8),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                mail = emailController.text;
                                password = passwordController.text;
                                name = userController.text;
                                age = ageController.text;
                                gender = genderController.text;
                                address = addressController.text;
                              });
                              registration();
                            }
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                        },
                        child: const Text(
                          "Already have an account? Sign In",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                // Gradient Circle at Bottom Left
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Color(0xFF05a4c8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Gradient Circle at Top Right
                Positioned(
                  top: 0,
                  right: 10,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.white,
                          Color(0xFF05a4c8),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $hint';
        }
        return null;
      },
    );
  }
}
