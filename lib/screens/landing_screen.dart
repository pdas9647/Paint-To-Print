import 'dart:math';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_shine/flutter_shine.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:paint_to_print/screens/auth/login_screen.dart';
import 'package:paint_to_print/services/global_methods.dart';

import 'auth/signup_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _loginAnonymously() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _firebaseAuth.signInAnonymously();
    } catch (error) {
      GlobalMethods.authErrorDialog(
        context,
        'Error Occurred',
        error.toString(),
      );
      print('error occurred ${error.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          /// background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/app_icon.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// above image
          // anonymous sign in
          Positioned(
            top: 50.0,
            right: 15.0,
            child: GestureDetector(
              onTap: _loginAnonymously,
              child: GradientText(
                'Anonymous',
                style: GoogleFonts.aladin(
                  fontSize: 25.0,
                  fontStyle: FontStyle.italic,
                  shadows: [
                    Shadow(
                      color: Colors.white,
                      offset: Offset(0, 3),
                      blurRadius: 10,
                    )
                  ],
                ),
                gradient: SweepGradient(
                  colors: [
                    Theme.of(context).primaryColorDark,
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColorLight,
                    Theme.of(context).accentColor,
                  ],
                ),
              ),
            ),
          ),
          Container(
            // color: Colors.lightBlueAccent,
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
            width: double.infinity,
            // welcome, welcome to paint to print, sign in & sign up
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // welcome
                FlutterShine(
                  builder: (BuildContext context, ShineShadow shineShadow) {
                    return GradientText(
                      'Welcome',
                      style: GoogleFonts.getFont(
                        'Cookie',
                        fontSize: 70.0,
                        letterSpacing: 5.0,
                        fontWeight: FontWeight.w700,
                        // shadows: shineShadow.shadows,
                      ),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.pinkAccent,
                          Colors.blueAccent,
                          Colors.yellowAccent,
                          Colors.redAccent,
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                // welcome to paint to print
                FlutterShine(
                  config: Config(shadowColor: Colors.red[300]),
                  light: Light(intensity: 1, position: Point(1, 2)),
                  builder: (BuildContext context, ShineShadow shineShadow) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        'Welcome to \nPaint to Print',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.courgette(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          // shadows: shineShadow.shadows,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Container(),
                ),
                // login, sign up
                Column(
                  children: [
                    // login, sign up
                    Row(
                      children: [
                        const SizedBox(width: 10.0),
                        // login
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                              // Navigator.push(
                              //   context,
                              //   PageTransition(
                              //     type: PageTransitionType.topToBottom,
                              //     child: LoginScreen(),
                              //   ),
                              // );
                            },
                            child: Container(
                              height: 45.0,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.pinkAccent.shade100,
                                    Colors.blueAccent.shade100,
                                    Colors.yellowAccent.shade100,
                                    Colors.redAccent.shade100,
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.5),
                                    blurRadius: 1.5,
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Feather.user_check,
                                    size: 18.0,
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    'Login',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.getFont(
                                      'Fira Sans',
                                      fontSize: 20.0,
                                      color: Colors.black87,
                                      letterSpacing: 0.8,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // sign up
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SignUpScreen(),
                                ),
                              );
                              // Navigator.push(
                              //   context,
                              //   PageTransition(
                              //     type: PageTransitionType.topToBottom,
                              //     child: SignUpScreen(),
                              //   ),
                              // );
                            },
                            child: Container(
                              height: 45.0,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.pinkAccent.shade100,
                                    Colors.blueAccent.shade100,
                                    Colors.yellowAccent.shade100,
                                    Colors.redAccent.shade100,
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.5),
                                    blurRadius: 1.5,
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Feather.user_plus,
                                    size: 18.0,
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    'Sign Up',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.getFont(
                                      'Fira Sans',
                                      fontSize: 20.0,
                                      color: Colors.black87,
                                      letterSpacing: 0.8,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
