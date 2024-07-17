import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class lupapw extends StatefulWidget {
  @override
  _lupapwState createState() => _lupapwState();
}

class _lupapwState extends State<lupapw> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  bool isLoading = false;
  bool showOtpInput = false;

  Future<void> sendResetPasswordRequest() async {
    setState(() {
      isLoading = true;
    });

    String email = emailController.text;

    String url = 'http://192.168.51.112:5000/request_reset_password';
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email}),
    );

    if (response.statusCode == 200) {
      print('Password reset email sent');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent')),
      );
      setState(() {
        showOtpInput = true;
      });
    } else {
      print('Failed to send password reset request');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send password reset request')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> submitVerificationCode() async {
    setState(() {
      isLoading = true;
    });

    String otp = otpController.text;
    String newPassword = newPasswordController.text;

    String url = 'http://192.168.51.112:5000/reset_password';
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'code': otp,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      print('Password changed successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password changed successfully')),
      );
      // Optionally navigate to a success screen or login screen
    } else {
      print('Failed to change password');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to change password')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Reset'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              height: 40,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xFFD8D0E3)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: TextField(
                controller: emailController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: isLoading ? null : sendResetPasswordRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              ),
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      'SEND RESET CODE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
            ),
            SizedBox(height: 20),
            if (showOtpInput) ...[
              Container(
                height: 40,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFFD8D0E3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: TextField(
                  controller: otpController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: 'Enter OTP',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 40,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFFD8D0E3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: TextField(
                  controller: newPasswordController,
                  style: TextStyle(color: Colors.black),
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: 'Enter new password',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : submitVerificationCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        'RESET PASSWORD',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: lupapw(),
  ));
}
