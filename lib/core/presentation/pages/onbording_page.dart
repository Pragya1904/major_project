import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:major_project/core/presentation/pages/home_page.dart';
import 'package:major_project/core/presentation/pages/login_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), // Replace LoginScreen() with your actual login screen widget
      );
    });
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient:  RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [
              Color(0xffC5C4FE).withOpacity(0.5),
              Color(0xFF6252DA).withOpacity(0.5),
              Color(0xFF2E2E48).withOpacity(0.5),
              Colors.transparent,
            ],
            stops: [0.3, 0.5, 0.7, 1.0],
          )
        //  image: DecorationImage(image: AssetImage("assets/images/bg.png"),fit: BoxFit.cover)
        ),
        child: Center(
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/logo.png"),)
              ),
            ),
          ),
        ),
      ),
    );
  }
}
