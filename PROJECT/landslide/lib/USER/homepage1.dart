import 'package:flutter/material.dart';
import 'package:landslide/USER/notification.dart';
import 'package:landslide/USER/raindirection.dart';
import 'package:landslide/USER/readings.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Landslide Prediction"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              // await fetchNotifications1();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade300, Colors.teal.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Monitor weather and predict landslides",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildButton(
                    context,
                    "Readings",
                    Icons.analytics,
                    Colors.teal.shade600,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LandslideDataScreen()),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildButton(
                    context,
                    "Rain Directions",
                    Icons.cloud,
                    Colors.blue.shade400,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DirectionScreen()),
                    ),
                  ),
                  SizedBox(height: 20),
                  // _buildButton(
                  //   context,
                  //   "Landslide Prediction",
                  //   Icons.terrain,
                  //   Colors.green.shade600,
                  //   () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => LandslidePredictionScreen()),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: Colors.white),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// Screen for Readings
class ReadingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Readings"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text(
          "This is the Readings Screen",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// Screen for Rain Directions
class RainDirectionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rain Directions"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          "This is the Rain Directions Screen",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// Screen for Landslide Prediction
class LandslidePredictionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Landslide Prediction"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          "This is the Landslide Prediction Screen",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
