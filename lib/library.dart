import 'package:flutter/material.dart';

class menu_perpustakaan extends StatelessWidget {
  const menu_perpustakaan({super.key});

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
        body: ListView(children: [
          Library(),
        ]),
      ),
    );
  }
}

class Library extends StatelessWidget {
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
          decoration: BoxDecoration(color: Color(0xFF454F82)),
          child: Stack(
            children: [
              Positioned(
                left: screenWidth * 0.13,
                top: screenHeight * 0.04,
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
                      height: 0.02,
                      letterSpacing: -0.41,
                    ),
                  ),
                ),
              ),
              ..._buildImageContainers(screenWidth, screenHeight),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildImageContainers(double screenWidth, double screenHeight) {
    List<Widget> containers = [];
    double containerWidth = screenWidth * 0.35;
    double containerHeight = screenHeight * 0.11;
    List<double> leftPositions = [0.04, 0.61]; // Left for left-aligned, right-aligned
    List<double> topPositions = [
      0.16, 0.3, 0.44, 0.58, 0.72, 0.86
    ]; // Positions for each row

    for (int i = 0; i < topPositions.length; i++) {
      for (int j = 0; j < leftPositions.length; j++) {
        double left = leftPositions[j] * screenWidth;
        double top = topPositions[i] * screenHeight;
        containers.add(
          Positioned(
            left: left,
            top: top,
            child: Container(
              width: containerWidth,
              height: containerHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://via.placeholder.com/145x99"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        );
      }
    }

    return containers;
  }
}
