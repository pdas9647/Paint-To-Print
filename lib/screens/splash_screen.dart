import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
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
        type: PageTransitionType.rippleRightUp,
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
      body: Image.asset(
        'assets/images/splash_screen_bg.png',
        height: height,
        width: width,
        fit: BoxFit.fill,
      ),
    );
  }
}
