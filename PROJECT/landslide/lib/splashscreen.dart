import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:animate_do/animate_do.dart';

import 'package:landslide/USER/homepage1.dart';
// import 'home_page_screen.dart'; // Import your home page screen

class CustomSplashScreen extends StatelessWidget { // Renamed class to CustomSplashScreen
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Logo
          FadeInUp(
            duration: Duration(seconds: 2),
            child: Image.asset(
              'assets/ICON.png',   // Ensure logo is in assets folder
              width: 150,
              height: 150,
            ),
          ),
          SizedBox(height: 20),
          // Animated Text
          BounceInUp(
            duration: Duration(seconds: 2),
            child: Text(
              'Landslide Prediction App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      nextScreen: HomePage(), // Transition to your home page after splash
      splashIconSize: 300,
      splashTransition: SplashTransition.scaleTransition,
      backgroundColor: Colors.teal, // Background color for the splash screen
      duration: 5000, // Duration of the splash screen (in milliseconds)
    );
  }
}
