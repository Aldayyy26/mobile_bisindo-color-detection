import 'dart:convert';
import 'dart:async';
import 'package:colordetection/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class halaman_daftar extends StatelessWidget {
  const halaman_daftar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(69, 79, 130, 1),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Daftar(),
        ],
      ),
    );
  }
}

final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();

Future<void> signup(BuildContext context) async {
  final String name = nameController.text;
  final String email = emailController.text;
  final String password = passwordController.text;
  final String confirmPassword = confirmPasswordController.text;

  if (name.isEmpty ||
      email.isEmpty ||
      password.isEmpty ||
      confirmPassword.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Silahkan isi bidang yang kosong')),
    );
    return;
  }

  if (password.length < 8) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kata sandi harus minimal 8 karakter')),
    );
    return;
  }

  if (password != confirmPassword) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password Salah')),
    );
    return;
  }

  try {
    final response = await http.post(
      Uri.parse('http://192.168.51.112:5000/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Clear the text fields
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      // Show success dialog with a short delay before navigation
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => halaman_login(),
              ),
              (route) => false,
            );
          });

          return AlertDialog(
            title: Text('Berhasil'),
            content: Text('Selamat, Anda telah terdaftar.'),
          );
        },
      );
    } else {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Terjadi kesalahan: $e')),
    );
  }
}

class Daftar extends StatefulWidget {
  @override
  _DaftarState createState() => _DaftarState();
}

class _DaftarState extends State<Daftar> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 50),
        Text(
          'DAFTAR AKUN SEKARANG',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.048,
            fontFamily: 'ABeeZee',
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        inputFile(
          label: "Username",
          controller: nameController,
        ),
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
        inputFile(
          label: "Konfirmasi Password",
          obscureText: _obscureConfirmPassword,
          controller: confirmPasswordController,
          togglePasswordVisibility: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => signup(context),
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color.fromRGBO(69, 79, 130, 1).withOpacity(0.5),
            backgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27),
              side: BorderSide(color: Color(0xFFD8D0E3)),
            ),
          ),
          child: Text(
            'DAFTAR',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontFamily: 'ABeeZee',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Sudah Punya Akun?"),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => halaman_login(),
                  ),
                );
              },
              child: Text(
                "Login Sekarang",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.043,
                ),
              ),
            ),
          ],
        ),
      ],
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
            borderSide: BorderSide(color: Colors.white),
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
