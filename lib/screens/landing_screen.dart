import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint_to_print/screens/auth/login_screen.dart';
import 'package:paint_to_print/screens/auth/signup_screen.dart';
import 'package:paint_to_print/services/global_methods.dart';
import 'package:paint_to_print/widgets/loading.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInCirc);
    controller.forward();
    animation.addStatusListener((status) {
      print(status);
    });
    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// image & Paint to print animation
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: MediaQuery.of(context).size.height * 0.50,
            child: Column(
              children: [
                /// app_icon
                Container(
                  height: 150.0,
                  width: 150.0,
                  child: Image.asset(
                    'assets/images/app_icon.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 10.0),

                /// typewriter text... paint to print
                TypewriterAnimatedTextKit(
                  text: ['Paint to Print'],
                  speed: Duration(milliseconds: 100),
                  textStyle: GoogleFonts.arimo(
                    fontSize: 35.0,
                    color: Theme.of(context).colorScheme.error,
                    // overflow: TextOverflow.fade,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          /// bottom card
          Positioned(
            bottom: 0.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.40,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30.0))),
              child: Card(
                elevation: 10.0,
                margin: EdgeInsets.all(0.0),
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30.0)),
                ),
                child: Column(
                  children: [
                    /// Welcome to Paint to Print
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: AutoSizeText(
                        'Welcome to App',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.arimo(
                          fontSize: 40.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    /// description
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12.0),
                      child: Text(
                        'App Description',
                        style: GoogleFonts.arimo(
                          fontSize: 20.0,
                          height: 2.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    Expanded(child: Container()),

                    /// login & sign up button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        /// login button
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: LoginScreen(),
                                type: PageTransitionType.fade,
                              ),
                            );
                          },
                          height: 50.0,
                          // minWidth: 200.0,
                          elevation: 10.0,
                          animationDuration: Duration(milliseconds: 100),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 10.0),
                          color: Theme.of(context).colorScheme.secondary,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Feather.user_check, color: Colors.white),
                              SizedBox(width: 7.0),
                              AutoSizeText(
                                'Sign in',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.fade,
                                style: GoogleFonts.arimo(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// sign up button
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: SignUpScreen(),
                                type: PageTransitionType.fade,
                              ),
                            );
                          },
                          height: 50.0,
                          // minWidth: 200.0,
                          elevation: 10.0,
                          animationDuration: Duration(milliseconds: 100),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 10.0),
                          color: Color(0xFFF34964),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Feather.user_plus, color: Colors.white),
                              SizedBox(width: 7.0),
                              AutoSizeText(
                                'Sign up',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.fade,
                                style: GoogleFonts.arimo(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
                  ],
                ),
              ),
            ),
          ),

          /// anonymous sign in
          Positioned(
            top: 50.0,
            right: 15.0,
            child: GestureDetector(
              onTap: _loginAnonymously,
              child: GradientText(
                'Anonymous',
                style: GoogleFonts.cookie(
                  fontSize: 25.0,
                  fontStyle: FontStyle.italic,
                  shadows: [
                    Shadow(
                      color: Colors.white,
                      offset: Offset(1, 1),
                      blurRadius: 10.0,
                    )
                  ],
                ),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFBB5898),
                    Color(0xFF8E44A3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          /// loading while signing in anonymously
          Positioned(
            bottom: 0.0,
            top: 0.0,
            right: 0.0,
            left: 0.0,
            child: Visibility(visible: _isLoading, child: Loading()),
          ),
        ],
      ),
    );
  }
}
