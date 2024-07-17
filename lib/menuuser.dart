import 'package:colordetection/kamera.dart';
import 'package:flutter/material.dart';

class menuuser extends StatelessWidget {
  const menuuser({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Container(
          width: screenWidth,
          height: screenHeight,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Color.fromRGBO(69, 79, 130, 1)),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: screenWidth,
                  height: screenHeight,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/bg1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: screenWidth * 0.13,
                top: screenHeight * 0.25,
                child: SizedBox(
                  width: screenWidth * 0.74,
                  height: screenHeight * 0.1,
                  child: Text(
                    'COLOR DETECTION',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight * 0.04,
                      fontFamily: 'Abril Fatface',
                      fontWeight: FontWeight.w400,
                      height: 1,
                      letterSpacing: -0.41,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: screenWidth * 0.05,
                top: screenHeight * 0.56,
                width: screenWidth * 0.9,
                height: screenHeight * 0.07,
                child: Container(
                  decoration: ShapeDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Kamera()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'DETEKSI',
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
                ),
              ),
              Positioned(
                left: screenWidth * 0.05,
                top: screenHeight * 0.64,
                width: screenWidth * 0.9,
                height: screenHeight * 0.07,
                child: Container(
                  decoration: ShapeDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutApp()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'ABOUT APP',
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
                ),
              ),
              Positioned(
                left: screenWidth * 0.05,
                top: screenHeight * 0.72,
                width: screenWidth * 0.9,
                height: screenHeight * 0.07,
                child: Container(
                  decoration: ShapeDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MenuPerpustakaan()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'LIBRARY',
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
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class YoloVideo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yolo Video'),
      ),
      body: Center(
        child: Text('Yolo Video Page'),
      ),
    );
  }
}

class AboutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About App'),
      ),
      body: Center(
        child: Text('About App Page'),
      ),
    );
  }
}

class MenuPerpustakaan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
      ),
      body: Center(
        child: Text('Library Page'),
      ),
    );
  }
}
