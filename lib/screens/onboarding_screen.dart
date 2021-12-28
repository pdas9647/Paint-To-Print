import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint_to_print/screens/user_state.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: 'Finish',
      onFinish: () {
        Navigator.pushReplacement(
          context,
          PageTransition(type: PageTransitionType.fade, child: UserState()),
        );
      },
      // finishButtonColor: Theme.of(context).primaryColor,
      finishButtonTextStyle: GoogleFonts.arimo(
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).primaryColor,
      ),
      skipTextButton: Text(
        'Skip',
        style: GoogleFonts.arimo(
          fontSize: 17.0,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColor,
        ),
      ),
      controllerColor: Theme.of(context).colorScheme.secondary,
      totalPage: 3,
      headerBackgroundColor: Colors.white,
      // pageBackgroundColor: Color(0xFFFAFAFA),
      pageBackgroundColor: Colors.white,
      background: [
        Image.asset(
          'assets/images/app_icon.png',
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
        ),
        Image.asset(
          'assets/images/scan_onboarding.png',
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
        ),
        Image.asset(
          'assets/images/ocr_onboarding.png',
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
        ),
      ],
      speed: 1.8,
      pageBodies: [
        // page 1
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height / 1.7),
              Text(
                'On your way...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'to find the perfect looking Onboarding for your app?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black26,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // page 2
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height / 1.7),
              Text(
                'You’ve reached your destination.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Sliding with animation',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black26,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // page 3
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height / 1.7),
              Text(
                'Start now!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Where everything is possible and customize your onboarding.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black26,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
