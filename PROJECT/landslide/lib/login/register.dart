import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:landslide/login/loginpage.dart';
import 'package:landslide/login/registrationap.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
     
      String name = _nameController.text;
      String phone = _phoneController.text;
      String email = _emailController.text;
      String password = _passwordController.text;

      // final authService = AuthService();
      final result = await registerUser(name, phone, email, password);
       print('jhb');
      if (result["success"]) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result["message"]),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loginpage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result["message"]),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.orange.shade900,
                  Colors.orange.shade800,
                  Colors.orange.shade400,
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeInUp(
                        duration: Duration(milliseconds: 1000),
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 0),
                      FadeInUp(
                        duration: Duration(milliseconds: 1300),
                        child: Text(
                          "Create a New Account",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 70),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: [
                              SizedBox(height: 40),
                              FadeInUp(
                                duration: Duration(milliseconds: 1400),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      child: TextFormField(
                                        controller: _nameController,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.person, color: Colors.orange.shade900),
                                          hintText: "Full Name",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Name is required';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      child: TextFormField(
                                        controller: _phoneController,
                                        style: TextStyle(color: Colors.black),
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.phone, color: Colors.orange.shade900),
                                          hintText: "Phone Number",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                        ),
                                        validator: _validatePhone,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      child: TextFormField(
                                        controller: _emailController,
                                        style: TextStyle(color: Colors.black),
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.email, color: Colors.orange.shade900),
                                          hintText: "Email",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                        ),
                                        validator: _validateEmail,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      child: TextFormField(
                                        controller: _passwordController,
                                        obscureText: true,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.lock, color: Colors.orange.shade900),
                                          hintText: "Password",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                        ),
                                        validator: _validatePassword,
                                      ),
                                    ),
                                    TextFormField(
                                      controller: _confirmPasswordController,
                                      obscureText: true,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock, color: Colors.orange.shade900),
                                        hintText: "Confirm Password",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.shade200,
                                      ),
                                      validator: _validateConfirmPassword,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 40),
                              FadeInUp(
                                duration: Duration(milliseconds: 1600),
                                child: MaterialButton(
                                  onPressed: _register,
                                  height: 50,
                                  color: Colors.orange[900],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 5,
                                  child: Center(
                                    child: Text(
                                      "Register",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
