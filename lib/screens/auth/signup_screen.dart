import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint_to_print/services/global_methods.dart';
import 'package:paint_to_print/widgets/loading.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup_screen';

  const SignUpScreen({Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _emailAddress = '';
  String _password = '';
  bool _obscureText = true;
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitForm() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    var date = DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = '${dateParse.day}-${dateParse.month}-${dateParse.year}';
    if (isValid) {
      _formKey.currentState.save();
      try {
        setState(() {
          _isLoading = true;
        });
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: _emailAddress.toLowerCase().trim(),
          password: _password.trim(),
        );
        final User user = _firebaseAuth.currentUser;
        final _uid = user.uid;
        var createdDate = user.metadata.creationTime.toString();
        user.updateDisplayName(_name);
        user.reload();
        await FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id': _uid,
          'name': _name,
          'email': _emailAddress,
          'joinedAt': formattedDate,
          'createdAt': createdDate,
          'authenticatedBy': 'email',
        });
        Navigator.canPop(context) ? Navigator.pop(context) : null;
        // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      } catch (error) {
        GlobalMethods.authErrorDialog(
          context,
          'Error Occurred',
          error.toString(),
        );
        print('error occurred: ${error.toString()}');
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
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFF34964),
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

            /// sign up
            Positioned(
              top: 30.0,
              left: 0.0,
              right: 0.0,
              child: Center(
                child: AutoSizeText(
                  'Sign Up',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.arimo(
                    fontSize: 50.0,
                    color: Colors.black,
                    shadows: [Shadow(color: Colors.black, blurRadius: 10.0)],
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
                height: MediaQuery.of(context).size.height * 0.70,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30.0))),
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

                        /// textformfield name
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            key: const ValueKey('name'),
                            validator: (name) {
                              if (name.isEmpty) {
                                return 'Please enter your name';
                              } else {
                                return null;
                              }
                            },
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColorDark),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              // filled: true,
                              labelText: 'Name',
                              labelStyle: GoogleFonts.arimo(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              hintText: 'Name',
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
                              prefixIcon: Icon(MaterialIcons.person),
                              // fillColor: Theme.of(context).backgroundColor,
                              contentPadding: EdgeInsets.all(15.0),
                            ),
                            onSaved: (value) {
                              _name = value;
                            },
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_emailFocusNode),
                          ),
                        ),

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
                              hintText: 'Enter your email...',
                              hintStyle: GoogleFonts.arimo(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              errorStyle: GoogleFonts.arimo(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              prefixIcon: Icon(MaterialCommunityIcons.email),
                              // fillColor: Theme.of(context).backgroundColor,
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
                                return 'Please enter your password';
                              } else if (password.length < 6) {
                                return 'Password should contain at least 6 characters';
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.name,
                            focusNode: _passwordFocusNode,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColorDark),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              // filled: true,
                              labelText: 'Password',
                              labelStyle: GoogleFonts.arimo(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              hintText: 'Password',
                              hintStyle: GoogleFonts.arimo(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              errorStyle: GoogleFonts.arimo(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColorDark,
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
                              // fillColor: Theme.of(context).backgroundColor,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  /// already have an account? sign in
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: LoginScreen(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: 'Already have an account?',
                              style: GoogleFonts.arimo(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            TextSpan(
                              text: '\nSign In',
                              style: GoogleFonts.arimo(
                                fontSize: 17.0,
                                color: Color(0xFFF34964),
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// sign up button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: MaterialButton(
                      onPressed: () {
                        _submitForm();
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
                      child: Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            /// while signing up loading
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
    );
  }
}
