import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


int? lid;

Future<Map<String, dynamic>> loginUser({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  final Dio dio = Dio();

  const String apiUrl = "http://192.168.168.51:5000/login/loginapi/";
  

  try {
    final response = await dio.post(
      apiUrl,
      data: {
        
        "username": email,
        "password": password,
      },
    );

    print("Server Response: ${response.data}");

    if (response.statusCode == 200) {
      final responseData = response.data as Map<String, dynamic>;

      if (responseData['status'] == true || responseData['status'] == 'true') {
lid=responseData['session_data']['user_id'];
print(lid=responseData['session_data']['user_id']);


        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomePage()),
        // );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Invalid email or password')),
        );
      }
      return responseData;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unexpected server response")),
      );
      return {"status": false, "message": "Unexpected server response"};
    }
  } on DioError catch (e) {
    print("DioError: ${e.response?.data}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.response?.data["reason"] ?? "Login failed due to an error.")),
    );
    return {
      "status": false,
      "message": e.response?.data["reason"] ?? "Login failed due to an error."
    };
  } catch (e) {
    print("Unexpected Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("An unexpected error occurred.")),
    );
    return {"status": false, "message": "An unexpected error occurred."};
  }
}
