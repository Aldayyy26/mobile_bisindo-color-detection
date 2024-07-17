import 'package:colordetection/login.dart';
import 'package:colordetection/menuuser.dart';
import 'package:flutter/material.dart';

class splash extends StatelessWidget {
  const splash ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(
          children: [
            SplashContent(),
          ],
        ),
      ),
    );
  }
}

class SplashContent extends StatelessWidget {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: screenWidth,
                height: screenHeight,
                child: Stack(
                  children: [
                    Positioned(
                      left: screenWidth * 0.012,
                      top: 0,
                      child: Container(
                        width: screenWidth * 0.988,
                        height: screenHeight * 0.35,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/bg1.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: screenWidth * 0.05,
                      top: screenHeight * 0.52,
                      child: Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.28,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/bg2.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: screenWidth * 0.06,
                      top: screenHeight * 0.43,
                      child: SizedBox(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.11,
                        child: Text(
                          'Aplikasi hand gesture dalam mengenali warna bisindo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenHeight * 0.025,
                            fontFamily: 'Aclonica',
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                            letterSpacing: 0.41,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: screenWidth * 0.1,
                      top: screenHeight * 0.17,
                      child: SizedBox(
                        width: screenWidth * 0.8,
                        height: screenHeight * 0.09,
                        child: Text(
                          'COLOR DETECTION',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenHeight * 0.04,
                            fontFamily: 'Aclonica',
                            fontWeight: FontWeight.w400,
                            height: 0.03,
                            letterSpacing: 0.41,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: screenWidth * 0.05,
                      top: screenHeight * 0.9,
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.07,
                      child: Container(
                        decoration: ShapeDecoration(
                          color: Color.fromRGBO(69, 79, 130, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => menuuser()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: SizedBox(
                            width: screenWidth * 0.65,
                            height: screenHeight * 0.03,
                            child: Text(
                              'CONTINUE',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color.fromRGBO(69, 79, 130, 1),
                                fontSize: screenHeight * 0.025,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: screenWidth * 0.05,
                      top: screenHeight * 0.82,
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.07,
                      child: Container(
                        decoration: ShapeDecoration(
                          color: Color.fromRGBO(69, 79, 130, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => halaman_login()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: SizedBox(
                            width: screenWidth * 0.65,
                            height: screenHeight * 0.03,
                            child: Text(
                              'LOGIN ADMIN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color.fromRGBO(69, 79, 130, 1),
                                fontSize: screenHeight * 0.025,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
