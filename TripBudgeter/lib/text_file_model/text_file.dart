import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator; // Add validator

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    this.controller,
    this.validator,
    required bool obsureText,
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: TextFormField(
        obscureText: _isObscured,
        controller: widget.controller,
        validator: widget.validator, // Use the validator
        decoration: InputDecoration(
          hintText: widget.hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(15),
          ),
          fillColor: Colors.white,
          filled: true,
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: _toggleVisibility,
                )
              : null,
        ),
      ),
    );
  }
}
