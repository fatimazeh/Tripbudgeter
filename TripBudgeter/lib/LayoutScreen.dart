import 'package:currency/Admin/AdminLogin.dart';
import 'package:currency/Admin/HeroPage.dart';
import 'package:currency/main.dart';

import 'package:flutter/material.dart';

class Layoutscreen extends StatelessWidget {
  const Layoutscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 600) {
        return SpaceExploringPage(); //Adminlogin();
      } else {
        return const SplashScreen();
      }
    });
  }
}
