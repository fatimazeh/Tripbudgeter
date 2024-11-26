import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const Button({super.key,
  required this.onTap,
  required this.text, required int height, required int width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Color.fromRGBO(13,110,253,1.000),
          borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),),
          ),
        ),
        );
  }
}