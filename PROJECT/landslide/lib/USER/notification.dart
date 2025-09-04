import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:landslide/USER/ipscreen.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List notifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications1();
  }

  Future<void> fetchNotifications1() async {
    final response = await http.get(Uri.parse("$baseUrl/notifications"));

    if (response.statusCode == 200) {
      setState(() {
        notifications = jsonDecode(response.body)['notifications'];
      });
    } else {
      print("Failed to load notifications");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: notifications.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(notifications[index]['description']),
                    subtitle: Text(
                        "${notifications[index]['date']} at ${notifications[index]['time']}"),
                    leading: Icon(Icons.warning, color: Colors.red),
                  ),
                  
                );
                

              },
            ),
    );
  }
}
