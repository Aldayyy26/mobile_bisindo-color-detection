import 'package:colordetection/aboutapp.dart';
import 'package:colordetection/admin.dart';
import 'package:colordetection/daftar.dart';
import 'package:colordetection/data.dart';
import 'package:colordetection/edit_profile_page.dart';
import 'package:colordetection/halamanlupapw.dart';
import 'package:colordetection/kamera.dart';
import 'package:colordetection/library.dart';
import 'package:colordetection/login.dart';
import 'package:colordetection/menuuser.dart';
import 'package:colordetection/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi  Color Bisindo',
      initialRoute: '/',
      routes: {
        '/': (context) => const splash(),
        '/halamanlogin': (context) => const halaman_login(),
        '/halamandaftar': (context) => halaman_daftar(),
        '/halamanlupapassowrd': (context) => lupapw(),
        '/halamanadmin': (context) => menu_admin(),
        '/halamanmenu': (context) => menuuser(),
        '/aboutapp': (context) => about_app(),
        '/halamandeteksi': (context) => Kamera(),
        '/library': (context) => menu_perpustakaan(),
        '/data': (context) => data(),
        '/EditProfilePage': (context) => EditProfilePage(),
        '/Yolo': (context) => YoloVideo(),
      },
    );
  }
}
