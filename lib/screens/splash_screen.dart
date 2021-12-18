import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'user_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 4), navigateToUserState);
  }

  void navigateToUserState() {
    Navigator.pushReplacementNamed(context, UserState.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Container(
              // height: MediaQuery.of(context).size.height * 0.90,
              width: MediaQuery.of(context).size.width * 0.90,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage('assets/images/app_icon.png'),
              //     fit: BoxFit.contain,
              //   ),
              // ),
              child: Image.asset(
                'assets/images/app_icon.png',
                height: MediaQuery.of(context).size.height * 0.90,
                width: MediaQuery.of(context).size.width * 0.90,
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 0.0,
            right: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: DefaultTextStyle(
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.alexBrush(
                    fontSize: 45.0,
                    letterSpacing: 1.7,
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(2.5, 2.5),
                        blurRadius: 5.0,
                        color: Color(0xFF3F0713),
                      ),
                    ],
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: TypewriterAnimatedTextKit(
                      text: ['Paint to Print'],
                      speed: Duration(milliseconds: 100),
                      textStyle: GoogleFonts.courgette(
                        fontSize: 35.0,
                        // overflow: TextOverflow.fade,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
