import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paint_to_print/services/global_methods.dart';
import 'package:paint_to_print/widgets/loading.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // wave
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.95,
              child: RotatedBox(
                quarterTurns: 2,
                child: WaveWidget(
                  config: CustomConfig(
                    gradients: [
                      [
                        Colors.pinkAccent.withOpacity(0.6),
                        Colors.pinkAccent.withOpacity(0.3),
                      ],
                      [
                        Colors.blueAccent.withOpacity(0.6),
                        Colors.blueAccent.withOpacity(0.3),
                      ],
                      [
                        Colors.greenAccent.withOpacity(0.6),
                        Colors.greenAccent.withOpacity(0.3),
                      ],
                    ],
                    durations: [4000, 5000, 7000],
                    heightPercentages: [0.01, 0.10, 0.15],
                    blur: const MaskFilter.blur(BlurStyle.normal, 10.0),
                    gradientBegin: Alignment.bottomLeft,
                    gradientEnd: Alignment.topRight,
                  ),
                  waveAmplitude: 0,
                  waveFrequency: 2,
                  size: const Size(double.infinity, double.infinity),
                ),
              ),
            ),
            // profile photo & form
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 80.0),
                  height: 120.0,
                  width: 120.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/app_icon.png'),
                      fit: BoxFit.cover,
                    ),
                    shape: BoxShape.rectangle,
                  ),
                  // child: Hero(
                  //   tag: 'logo',
                  //   child: Container(
                  //     height: 200.0,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(20.0),
                  //       shape: BoxShape.rectangle,
                  //     ),
                  //     child: Image.asset('assets/images/app_icon.png'),
                  //   ),
                  // ),
                ),
                const SizedBox(height: 30.0),
                // form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // textformfield name
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
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            filled: true,
                            labelText: 'Name',
                            labelStyle: GoogleFonts.getFont(
                              'Courgette',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            hintText: 'Enter your name...',
                            hintStyle: GoogleFonts.getFont(
                              'Courgette',
                              fontSize: 16.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                            errorStyle: GoogleFonts.getFont(
                              'Courgette',
                              fontSize: 16.0,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w500,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            prefixIcon: Icon(MaterialIcons.person),
                            fillColor: Theme.of(context).backgroundColor,
                          ),
                          onSaved: (value) {
                            _name = value;
                          },
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_emailFocusNode),
                        ),
                      ),
                      // textformfield email
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
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            filled: true,
                            labelText: 'Email',
                            labelStyle: GoogleFonts.getFont(
                              'Courgette',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            hintText: 'Enter your email...',
                            hintStyle: GoogleFonts.getFont(
                              'Courgette',
                              fontSize: 16.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                            errorStyle: GoogleFonts.getFont(
                              'Courgette',
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
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passwordFocusNode),
                        ),
                      ),
                      // textformfield password
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
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            filled: true,
                            labelText: 'Password',
                            labelStyle: GoogleFonts.getFont(
                              'Courgette',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            hintText: 'Enter your password...',
                            hintStyle: GoogleFonts.getFont(
                              'Courgette',
                              fontSize: 16.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                            errorStyle: GoogleFonts.getFont(
                              'Courgette',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.redAccent,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            prefixIcon: Icon(MaterialIcons.security),
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
                            fillColor: Theme.of(context).backgroundColor,
                          ),
                          obscureText: _obscureText,
                          onSaved: (value) {
                            _password = value;
                          },
                        ),
                      ),
                      // signup button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Material(
                            // color: Colors.lightBlueAccent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            elevation: 8.0,
                            child: InkWell(
                              onTap: () {
                                _submitForm();
                                // Navigator.of(context).pushNamed(LoginScreen.routeName);
                              },
                              child: Container(
                                // margin: EdgeInsets.only(bottom: 15.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 10.0),
                                // height: 36.0,
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
                                  borderRadius: BorderRadius.circular(30.0),
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
                                    Icon(Feather.user_plus, size: 18.0),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      'Sign Up',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.getFont(
                                        'Courgette',
                                        fontSize: 20.0,
                                        letterSpacing: 0.8,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: _isLoading,
                  child: Center(
                    child: Loading(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
