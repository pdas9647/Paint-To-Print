import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paint_to_print/services/global_methods.dart';
import 'package:paint_to_print/widgets/loading.dart';

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
  bool _isLoading = false;

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
            .sendPasswordResetEmail(email: _emailAddress.trim().toLowerCase())
            .then(
              (value) => Fluttertoast.showToast(
                msg: 'Reset Link Sent to $_emailAddress',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Color(0xFFF0E9D2),
                textColor: Color(0xFF141E61),
                fontSize: 16.0,
              ),
            );
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        GlobalMethods.authErrorDialog(
          context,
          'Error Occurred',
          error.toString(),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            body: Loading(),
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.pinkAccent.withOpacity(0.6),
                      Colors.blueAccent.withOpacity(0.6),
                      Colors.greenAccent.withOpacity(0.6),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.10),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Forget Password',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: GoogleFonts.getFont(
                          'Courgette',
                          fontSize: 30.0,
                          letterSpacing: 1.4,
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    // textformfield email
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Form(
                        key: _formKey,
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
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            filled: true,
                            labelText: 'Email',
                            labelStyle: GoogleFonts.getFont(
                              'Fira Sans',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            hintText: 'Enter your email...',
                            hintStyle: GoogleFonts.getFont(
                              'Fira Sans',
                              fontSize: 16.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                            errorStyle: GoogleFonts.getFont(
                              'Fira Sans',
                              fontSize: 16.0,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w500,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            prefixIcon: Icon(MaterialCommunityIcons.email),
                            fillColor: Theme.of(context).backgroundColor,
                          ),
                          onSaved: (value) {
                            _emailAddress = value;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: InkWell(
                        onTap: () {
                          _submitForm();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          height: 50.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.pinkAccent.shade100,
                                Colors.blueAccent.shade100,
                                Colors.yellowAccent.shade100,
                                Colors.redAccent.shade100,
                              ],
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
                                MaterialIcons.security,
                                size: 20.0,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 15.0),
                              Text(
                                'Reset Password',
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
                  ],
                ),
              ),
            ),
          );
  }
}
