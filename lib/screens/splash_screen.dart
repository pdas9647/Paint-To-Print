import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint_to_print/screens/onboarding_screen.dart';
import 'package:paint_to_print/services/first_time_open.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirstTimeOpen firstTimeOpen = FirstTimeOpen();
  SharedPreferences sharedPreferences;
  bool isFirstTimeOpening = true;

  Future<void> getFirstTimeOpenValue() async {
    sharedPreferences = await SharedPreferences.getInstance();
    isFirstTimeOpening = sharedPreferences.getBool('FIRST_TIME_OPEN') ?? true;
    if (isFirstTimeOpening == null) {
      firstTimeOpen.setFirstTimeOpenValue(true);
    } else if (isFirstTimeOpening == true) {
      firstTimeOpen.setFirstTimeOpenValue(false);
    } else if (isFirstTimeOpening == false) {
      firstTimeOpen.setFirstTimeOpenValue(false);
    }
    isFirstTimeOpening
        ? Timer(Duration(seconds: 4), navigateToOnBoardingScreen)
        : Timer(Duration(seconds: 4), navigateToUserState);
    print('43. isFirstTimeOpening: $isFirstTimeOpening');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFirstTimeOpenValue();
  }

  void navigateToOnBoardingScreen() {
    Navigator.pushReplacement(
      context,
      PageTransition(
        child: OnBoardingScreen(),
        type: PageTransitionType.fade,
      ),
    );
  }

  void navigateToUserState() {
    Navigator.pushReplacementNamed(context, UserState.routeName);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: width,
            height: height,
            child: Image.asset(
              'assets/images/splash_screen_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: height * 0.10,
            left: 0.0,
            right: 0.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/app_icon_without_bg.png',
                      width: width * 0.25,
                      height: width * 0.25,
                    ),
                    DefaultTextStyle(
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.alexBrush(
                        fontSize: width * 0.10,
                        letterSpacing: 3.0,
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                            offset: Offset(2.5, 2.5),
                            blurRadius: 5.0,
                            color: Color(0xFF3F0713),
                          ),
                        ],
                      ),
                      child: TypewriterAnimatedTextKit(
                        text: ['Paint to Print'],
                        speed: Duration(milliseconds: 100),
                        textStyle: GoogleFonts.satisfy(
                          fontSize: width * 0.10,
                          letterSpacing: 3.0,
                          // overflow: TextOverflow.fade,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.05),
                Text(
                  'You Write, We Digitize...',
                  style: GoogleFonts.arimo(
                    fontSize: width * 0.08,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
