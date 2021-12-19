import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint_to_print/services/global_methods.dart';

import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgot_password_screen';

  const ForgotPasswordScreen({Key key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _emailAddress = '';

  void _submitForm() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      ;
      _formKey.currentState.save();
      try {
        await _firebaseAuth
            .sendPasswordResetEmail(email: _emailAddress.trim().toLowerCase())
            .then(
              (value) => Fluttertoast.showToast(
                msg: 'Password reset link sent to $_emailAddress',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                textColor: Colors.white,
                fontSize: 17.0,
              ),
            );
        // Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        GlobalMethods.authErrorDialog(
          context,
          'Error Occurred',
          error.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF534D41),
      body: SafeArea(
        child: Stack(
          children: [
            /// back button
            Positioned(
              top: 5.0,
              left: 10.0,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),

            /// forgot your password
            Positioned(
              top: 30.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                padding: EdgeInsets.all(20.0),
                // color: Colors.greenAccent,
                child: AutoSizeText(
                  'Forgot your \npassword?',
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.arimo(
                    fontSize: 45.0,
                    color: Colors.white,
                    // shadows: [Shadow(color: Colors.black, blurRadius: 10.0)],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            /// container --> card --> form
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.65,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30.0)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20.0,
                      color: Colors.black,
                      offset: Offset(3, 3),
                      blurStyle: BlurStyle.outer,
                    ),
                  ],
                ),
                child: Card(
                  elevation: 10.0,
                  margin: EdgeInsets.all(0.0),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30.0)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(height: 60.0),

                        /// textformfield email
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            key: const ValueKey('email'),
                            validator: (email) {
                              if (email.isEmpty || !email.contains('@')) {
                                return 'Please enter your email';
                              } else {
                                return null;
                              }
                            },
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColorDark),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              // filled: true,
                              labelText: 'Email',
                              labelStyle: GoogleFonts.arimo(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              hintText: 'Enter your registered email',
                              hintStyle: GoogleFonts.arimo(
                                fontSize: 16.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                              errorStyle: GoogleFonts.arimo(
                                fontSize: 16.0,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w500,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              prefixIcon: Icon(MaterialCommunityIcons.email),
                              contentPadding: EdgeInsets.all(15.0),
                            ),
                            onSaved: (value) {
                              setState(() {
                                _emailAddress = value;
                              });
                            },
                          ),
                        ),

                        /// reset password
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 20.0),
                          child: MaterialButton(
                            elevation: 10.0,
                            height: 50.0,
                            animationDuration: Duration(milliseconds: 100),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0))),
                            padding: EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 10.0),
                            color: Color(0xFF534D41),
                            onPressed: () {
                              print(_emailAddress);
                              _submitForm();
                            },
                            child: AutoSizeText(
                              'Reset Password',
                              style: GoogleFonts.arimo(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
          // Navigator.of(context).pop();
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        child: Icon(Icons.arrow_forward, color: Colors.white),
        backgroundColor: Color(0xFF534D41),
      ),
    );
  }
}
