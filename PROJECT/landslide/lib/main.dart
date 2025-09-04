import 'package:flutter/material.dart';
import 'package:landslide/USER/ipscreen.dart';
// import 'package:landslide/USER/Homepage.dart';
// import 'package:landslide/USER/alertmode.dart';
// import 'package:landslide/USER/complaint&fdbk.dart';
// import 'package:landslide/USER/editprofile.dart';
// import 'package:landslide/USER/emergency.dart';
// import 'package:landslide/USER/send_review.dart';
// import 'package:landslide/login/loginpage.dart';
import 'package:landslide/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IpAddressInputPage(),
      //Loginpage(),
          // UserManagementScreen(),
          // AlertModeScreen(),
          // ComplaintsFeedbackScreen(),
          // EmergencyContactScreen(),
          // SendReviewScreen(),
          // HomePageScreen(),
    );
  }
}
