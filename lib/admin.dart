import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'aboutapp.dart';
import 'data.dart';
import 'edit_profile_page.dart';
import 'kamera.dart';
import 'library.dart';
import 'login.dart';

class menu_admin extends StatelessWidget {
  const menu_admin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => halaman_login()),
                );
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            Menu(),
          ],
        ),
      ),
    );
  }
}

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String userName = '[Loading]...';
  String greeting = '';
  String? _profilePictureUrl;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    setGreeting();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('accessToken');

    if (token == null) {
      setState(() {
        userName = 'No token found';
      });
      return;
    }

    final response = await http.get(
      Uri.parse('http://192.168.51.112:5000/protected'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        userName = data['name'];
        _profilePictureUrl = data['profile_picture'] ?? prefs.getString('profilePictureUrl');
      });

      // Save profile picture URL to SharedPreferences
      if (data['profile_picture'] != null) {
        await prefs.setString('profilePictureUrl', data['profile_picture']);
      }
    } else {
      setState(() {
        userName = 'Error loading username';
      });
    }
  }

  void setGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF454F82), Color(0xFF2A3A5B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.1),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
              if (result == true) {
                fetchUserData(); // Refresh user data after returning from EditProfilePage
              }
            },
            child: CircleAvatar(
              radius: screenWidth * 0.15,
              backgroundImage: _profilePictureUrl != null
                  ? NetworkImage(_profilePictureUrl!)
                  : AssetImage('assets/default_profile.png') as ImageProvider,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Hai $userName',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.07,
              fontFamily: 'Abril Fatface',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            '$greeting',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.07,
              fontFamily: 'Abril Fatface',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: screenHeight * 0.05),
          ButtonFeature(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            title: 'DETEKSI',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Kamera()),
              );
            },
          ),
          SizedBox(height: screenHeight * 0.02),
          ButtonFeature(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            title: 'ABOUT APP',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutApp()),
              );
            },
          ),
          SizedBox(height: screenHeight * 0.02),
          ButtonFeature(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            title: 'LIBRARY',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => menu_perpustakaan()),
              );
            },
          ),
          SizedBox(height: screenHeight * 0.02),
          ButtonFeature(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            title: 'DATA WARNA',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => data()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ButtonFeature extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String title;
  final VoidCallback onPressed;

  const ButtonFeature({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.07,
      decoration: ShapeDecoration(
        color: Colors.white.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color.fromRGBO(69, 79, 130, 1),
            fontSize: screenHeight * 0.025,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      ),
    );
  }
}
