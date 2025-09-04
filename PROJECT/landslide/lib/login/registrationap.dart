
 import 'package:dio/dio.dart';
   final Dio _dio = Dio();
Future<Map<String, dynamic>> registerUser(String name, String phone, String email, String password) async {
  var baseUrl;
  final url = "$baseUrl/login/userregistrationapi";
  try {
    final response = await _dio.post(
      url,
      data: {
        "first_name": name,
        "phone_no": phone,
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode == 201) {
      return {"success": true, "message": "Registration successful"};
    } else {
      return {"success": false, "message": response.data['detail'] ?? "An error occurred"};
    }
  } on DioError catch (e) {
    print(e);
    if (e.response != null && e.response?.data != null) {
      return {"success": false, "message": e.response?.data.toString()};
    } else {
      return {"success": false, "message": "Network error: ${e.message}"};
    }
  }
}
