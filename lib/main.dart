import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paint_to_print/screens/splash_screen.dart';
import 'package:paint_to_print/screens/user_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Paint to Print',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                color: Color(0xFF1F3A40),
                centerTitle: true,
                titleTextStyle: GoogleFonts.satisfy(
                  fontSize: 30.0,
                  letterSpacing: 1.5,
                ),
              ),
              primaryColor: Color(0xFF1F3A40),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: Color(0xFFF2BA52),
                error: Color(0xFFF05454),
                // 0xFF26A3BF
              ),
            ),
            home: const SplashScreen(),
            routes: {
              UserState.routeName: (ctx) => UserState(),
            },
          );
        });
  }
}
