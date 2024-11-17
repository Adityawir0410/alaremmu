import 'package:flutter/material.dart';
import 'package:alaremmu/ui/screen/onboard/onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to OnboardScreen after a delay
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F6179), // Dark teal at the top
              Color(0xFF367E8C),
              Color(0xFF9CC9BE),
              Color(0xFFC8E9D4), // Light mint at the bottom
            ],
            stops: [0.0, 0.32, 0.85, 1.0],
          ),
        ),
        child: Center(
          child: Text(
            'ALAREM',
            style: TextStyle(
              fontSize: 45,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
