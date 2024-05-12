import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:major_project/core/presentation/pages/home_page.dart';
import 'package:major_project/core/presentation/pages/login_page.dart';

import '../../../constants.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
         gradient:  radialGradient
         , color: canvasColor
        //  image: DecorationImage(image: AssetImage("assets/images/bg.jpeg.png"),fit: BoxFit.cover)
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
