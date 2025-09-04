import 'package:dio/dio.dart';
import 'package:landslide/USER/ipscreen.dart';

class ApiService {
  final Dio _dio = Dio();


  Future<Map<String, dynamic>> fetchReadings() async {
  try {
    final response = await _dio.get('$baseUrl/readings');
    print('Response Status Code: ${response.statusCode}');
    print('Response Data: ${response.data}');

    if (response.statusCode == 200 && response.data.isNotEmpty) {
      return response.data;
    } else {
      throw Exception('Failed to load readings');
    }
  } on DioException catch (e) {
    print('Dio Error: ${e.message}');
    throw Exception('Failed to fetch readings: ${e.message}');
  }
  }}

