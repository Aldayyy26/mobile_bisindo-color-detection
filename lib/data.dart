import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class data extends StatefulWidget {
  @override
  _dataState createState() => _dataState();
}

class _dataState extends State<data> {
  final String url ='http://192.168.51.112:8501'; // Replace with your Flask server URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Streamlite View'),
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