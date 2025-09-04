import 'dart:async';

import 'package:flutter/material.dart';
import 'package:landslide/USER/readingsapi.dart';


class LandslideDataScreen extends StatefulWidget {
  const LandslideDataScreen({super.key});

  @override
  _LandslideDataScreenState createState() => _LandslideDataScreenState();
}

class _LandslideDataScreenState extends State<LandslideDataScreen> {
  final ApiService _apiService = ApiService();

  String? temperature;
  String? humidity;
  String? moisture;
  String? tilt;
  String? rain;
  String? waterlevel;
  bool isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchData();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    try {
      final data = await _apiService.fetchReadings();
      setState(() {
        temperature = data['temperature'];
        humidity = data['humidity'];
        moisture = data['soil'];
        tilt = data['tilt'];
        // rain = data['rain'];
        // waterlevel = data['waterlevel'];
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landslide Data'),
        backgroundColor: const Color.fromARGB(255, 147, 128, 122),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDataCard('Temperature', '${temperature ?? 'N/A'} °C', Icons.thermostat),
                    const SizedBox(height: 16),
                    _buildDataCard('Humidity', '${humidity ?? 'N/A'} %', Icons.water_drop),
                    const SizedBox(height: 16),
                    _buildDataCard('Soil Moisture', '${moisture ?? 'N/A'} %', Icons.grass),
                    const SizedBox(height: 16),
                    _buildDataCard('Tilt', '${tilt ?? 'N/A'} °', Icons.sync),
                    // const SizedBox(height: 16),
                    // _buildDataCard('Rain', '${rain ?? 'N/A'} mm', Icons.beach_access),
                    // SizedBox(height: 16),
                    // _buildDataCard('waterlevel', '${waterlevel ?? 'N/A'} ', Icons.speed),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildDataCard(String label, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}