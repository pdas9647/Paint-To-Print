import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'app_icon',
                      child: Container(
                        child: Image.asset('assets/images/app_icon.png'),
                        height: controller.value * 70,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Flexible(
                      child: Align(
                        alignment: Alignment.center,
                        child: TypewriterAnimatedTextKit(
                          text: ['Paint to Print'],
                          speed: Duration(milliseconds: 100),
                          textStyle: GoogleFonts.courgette(
                            fontSize: 35.0,
                            color: Theme.of(context).colorScheme.error,
                            // overflow: TextOverflow.fade,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      /*DefaultTextStyle(
                        maxLines: 1,
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
                      ),*/
                    ),
                  ],
                ),
                SizedBox(height: 48.0),

                /// sign in
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    elevation: 8.0,
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(30.0),
                    child: MaterialButton(
                      onPressed: () {
                        print('Sign In');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      minWidth: 200.0,
                      height: 42.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Feather.user_check, size: 18.0),
                          SizedBox(width: 10.0),
                          Text(
                            'Sign In',
                            style: GoogleFonts.courgette(
                              fontSize: 18.0,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// sign up
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(30.0),
                    elevation: 8.0,
                    child: MaterialButton(
                      onPressed: () {
                        print('Register');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
                      },
                      minWidth: 200.0,
                      height: 42.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Feather.user_plus, size: 18.0),
                          SizedBox(width: 10.0),
                          Text(
                            'Sign Up',
                            style: GoogleFonts.courgette(
                              fontSize: 18.0,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
        ],
      ),
    );
  }
}
