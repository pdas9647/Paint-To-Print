import 'dart:async';

import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            // top: 0.0,
            right: -100.0,
            // left: 0.0,
            bottom: MediaQuery.of(context).size.height / 3,
            child: CircleAvatar(
              radius: 400.0,
              backgroundColor: Color(0xFF534D41),
            ),
          ),
          Positioned(
            // top: 0.0,
            right: 30.0,
            // left: 0.0,
            bottom: MediaQuery.of(context).size.height / 2,
            child: CircleAvatar(
              radius: 250.0,
              backgroundColor: Color(0xFFFEE53E),
            ),
          ),
          Positioned(
            // top: 0.0,
            right: MediaQuery.of(context).size.width / 2,
            // left: 0.0,
            bottom: MediaQuery.of(context).size.height / 1.5,
            child: CircleAvatar(
              radius: 155.0,
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
      /*Stack(
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

       */
    );
  }
}
