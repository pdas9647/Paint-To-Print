import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint_to_print/services/global_methods.dart';
import 'package:paint_to_print/widgets/loading.dart';

import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login_screen';

  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _emailAddress = '';
  String _password = '';
  String _errorMsg = '';
  bool _obscureText = true;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isLoading = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void _submitForm() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState.save();
      try {
        await _firebaseAuth
            .signInWithEmailAndPassword(
          email: _emailAddress.toLowerCase().trim(),
          password: _password.trim(),
        )
            .then((value) {
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        });
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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.secondary,
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

            /// sign in
            Positioned(
              top: 30.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.16,
                // color: Colors.redAccent,
                child: Center(
                  child: AutoSizeText(
                    'Sign In',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.arimo(
                      fontSize: 50.0,
                      color: Colors.white,
                      // shadows: [Shadow(color: Colors.black, blurRadius: 10.0)],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            /// container --> card --> form
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.70,
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
                                _errorMsg = 'Please enter your email';
                              } else {
                                _errorMsg = null;
                              }
                              return _errorMsg;
                            },
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            focusNode: _emailFocusNode,
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
                              hintText: 'Email',
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
                              _emailAddress = value;
                            },
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passwordFocusNode),
                          ),
                        ),

                        /// textformfield password
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            key: const ValueKey('password'),
                            validator: (password) {
                              if (password.isEmpty) {
                                _errorMsg = 'Please enter your password';
                              } else if (password.length < 6) {
                                _errorMsg =
                                    'Password should contain at least 6 characters';
                              } else {
                                _errorMsg = null;
                              }
                              return _errorMsg;
                            },
                            keyboardType: TextInputType.name,
                            focusNode: _passwordFocusNode,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColorDark),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              labelText: 'Password',
                              labelStyle: GoogleFonts.arimo(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              hintText: 'Enter your password...',
                              hintStyle: GoogleFonts.arimo(
                                fontSize: 16.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                              errorStyle: GoogleFonts.arimo(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.redAccent,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              prefixIcon: Icon(MaterialIcons.security),
                              contentPadding: EdgeInsets.all(15.0),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: _obscureText
                                    ? Icon(MaterialIcons.visibility)
                                    : Icon(MaterialIcons.visibility_off),
                              ),
                            ),
                            obscureText: _obscureText,
                            onSaved: (value) {
                              _password = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// forgot password & sign in ->
            Positioned(
              bottom: 15.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.arimo(
                      fontSize: 15.0,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                      color: Color(0xFF141E61),
                    ),
                  ),
                ),
              ),
            ),

            /// while signing in loading
            Positioned(
              top: 0.0,
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Visibility(
                visible: _isLoading,
                child: Loading(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        onPressed: _submitForm,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        child: Icon(Icons.arrow_forward, color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
