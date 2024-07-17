import 'package:colordetection/admin.dart';
import 'package:colordetection/daftar.dart';
import 'package:colordetection/halamanlupapw.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(69, 79, 130, 1), // Ubah warna latar belakang sesuai keinginan Anda
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Daftar(),
        ],
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          if (snapshot.data == true) {
            return menu_admin();
          } else {
            return halaman_login();
          }
        }
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('accessToken');
  }
}

class halaman_login extends StatelessWidget {
  const halaman_login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Login(),
        ],
      ),
    );
  }
}

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

Future<void> login(BuildContext context) async {
  final String email = emailController.text;
  final String password = passwordController.text;

  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill all fields')),
    );
    return;
  }

  final response = await http.post(
    Uri.parse('http://192.168.51.112:5000/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final String accessToken = data['access_token'];

    // Save token to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);

    // Navigate to the home screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => menu_admin(),
      ),
    );
  } else {
    final data = jsonDecode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(data['message'])),
    );
  }
}

Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('accessToken');

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => halaman_login(),
    ),
  );
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 50), // Add some space at the top
          Text(
            "Welcome Back!",
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.08,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20), // Add some space between the title and input fields
          inputFile(
            label: "Email",
            controller: emailController,
          ),
          inputFile(
            label: "Password",
            obscureText: _obscurePassword,
            controller: passwordController,
            togglePasswordVisibility: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => lupapw(),
                  ),
                );
              },
              child: Text(
                "Forgot your password?",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () => login(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27),
                ),
                elevation: 5.0, // Add shadow for better visual effect
              ),
              child: Text(
                'LOGIN',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 20), // Add some space between the buttons
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => halaman_daftar(),
                  ),
                );
              },
              child: Text(
                "Don't have an account? Sign Up",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 20), // Add some space at the bottom
        ],
      ),
    );
  }
}

Widget inputFile({
  required String label,
  bool obscureText = false,
  required TextEditingController controller,
  VoidCallback? togglePasswordVisibility,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 5),
      TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          hintText: 'Enter your $label',
          hintStyle: TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          border: OutlineInputBorder(),
          suffixIcon: togglePasswordVisibility != null
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                  ),
                  onPressed: togglePasswordVisibility,
                )
              : null,
        ),
        style: TextStyle(color: Colors.white),
      ),
      SizedBox(height: 10),
    ],
  );
}
