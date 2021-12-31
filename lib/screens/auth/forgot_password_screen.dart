import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint_to_print/screens/auth/login_screen.dart';
import 'package:paint_to_print/services/global_methods.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgot_password_screen';

  const ForgotPasswordScreen({Key key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  ScrollController _scrollController;
  var top = 0.0;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _emailAddress = '';
  String _errorMsg = '';

  void _submitForm() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
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
        Navigator.pushReplacement(
          context,
          PageTransition(
            child: LoginScreen(),
            type: PageTransitionType.fade,
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          /// sliver appbar
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.35,
            collapsedHeight: kToolbarHeight,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            floating: true,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                top = constraints.biggest.height;
                return Container(
                  color: Color(0xFF676FA3),
                  child: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    centerTitle: true,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedOpacity(
                          opacity: top <= 110.0 ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: AutoSizeText(
                            'Forgot your password?',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: GoogleFonts.arimo(
                              color: Color(0xFFEEF2FF),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    background: Center(
                      child: AutoSizeText(
                        'Forgot your \npassword?',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: GoogleFonts.arimo(
                          fontSize: 50.0,
                          color: Color(0xFFEEF2FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// sliver body
          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 15.0),

                  /// textformfield email
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      key: const ValueKey('email'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) {
                        if (email.isEmpty || !email.contains('@')) {
                          _errorMsg = 'Please enter a valid email';
                        } else {
                          _errorMsg = null;
                        }
                        return _errorMsg;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                            width: 2.0,
                          ),
                        ),
                        labelText: 'Email',
                        labelStyle: GoogleFonts.arimo(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        hintText: 'Enter your email...',
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
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        prefixIcon: Icon(MaterialCommunityIcons.email),
                        contentPadding: EdgeInsets.all(15.0),
                      ),
                      onSaved: (value) {
                        _emailAddress = value;
                      },
                    ),
                  ),

                  /// reset password
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                    width: MediaQuery.of(context).size.width,
                    child: MaterialButton(
                      elevation: 10.0,
                      height: 50.0,
                      animationDuration: Duration(milliseconds: 100),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 10.0),
                      color: Color(0xFF676FA3),
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
        ],
      ),
    );
  }
}
