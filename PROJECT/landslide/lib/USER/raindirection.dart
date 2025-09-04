import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:landslide/USER/ipscreen.dart';



class DirectionScreen extends StatefulWidget {
  @override
  _DirectionScreenState createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {
  String direction = "Fetching...";

  @override
  void initState() {
    super.initState();
    fetchDirection();
  }

  Future<void> fetchDirection() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get-directions'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          direction = data['direction'];
        });
      } else {
        setState(() {
          direction = "Error fetching direction";
        });
      }
    } catch (e) {
      setState(() {
        direction = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rain Direction'),
      ),
      body: Center(
        child: Text(
          direction,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchDirection,
        child: Icon(Icons.refresh),
        tooltip: "Refresh",
      ),
    );
  }
}
