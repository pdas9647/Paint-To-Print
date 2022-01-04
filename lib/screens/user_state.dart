import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paint_to_print/widgets/loading_fading_circle.dart';

import 'bottom_bar_screen.dart';
import 'landing_screen.dart';

class UserState extends StatelessWidget {
  static const String routeName = '/user_state';

  const UserState({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        print('userSnapshot: $userSnapshot');
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: LoadingFadingCircle(),
          );
        } else if (userSnapshot.connectionState == ConnectionState.active) {
          if (userSnapshot.hasData) {
            print('The user has already logged in ${userSnapshot.data}');
            return const BottomBarScreen();
          } else {
            print('The user didn\'t log in');
            return const LandingScreen();
          }
        } else if (userSnapshot.hasError) {
          return Center(
            child: Text(
              'Error occurred',
              style: GoogleFonts.sriracha(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrangeAccent,
              ),
            ),
          );
        } else {
          return Center(
            child: Text(
              'Error occurred',
              style: GoogleFonts.sriracha(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrangeAccent,
              ),
            ),
          );
        }
      },
    );
  }
}
