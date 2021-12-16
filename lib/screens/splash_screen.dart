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
    Timer(Duration(seconds: 5), navigateToUserState);
  }

  void navigateToUserState() {
    Navigator.pushReplacementNamed(context, UserState.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/app_icon.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 0.0,
            right: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: DefaultTextStyle(
                textAlign: TextAlign.center,
                style: GoogleFonts.alexBrush(
                  fontSize: 45.0,
                  letterSpacing: 5,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      'Paint to Print',
                      curve: Curves.easeInCubic,
                      speed: Duration(milliseconds: 50),
                    ),
                  ],
                  repeatForever: true,
                  // pause: const Duration(milliseconds: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
