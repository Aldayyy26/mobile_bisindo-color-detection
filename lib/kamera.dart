import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Kamera extends StatefulWidget {
  @override
  _KameraState createState() => _KameraState();
}

class _KameraState extends State<Kamera> {
  final String url ='http://172.20.10.4:5000/realtime'; // Replace with your Flask server URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deteksi Warna'),
        backgroundColor: Colors.green,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(url), // Gunakan WebUri sebagai pengganti Uri
        ),
      ),
    );
  }
}