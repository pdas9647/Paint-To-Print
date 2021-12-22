import 'package:backdrop/backdrop.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:paint_to_print/screens/all_docs.dart';
import 'package:paint_to_print/widgets/back_layer_menu.dart';

import 'canvas/canvas_view_screen.dart';
import 'home_screen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key key}) : super(key: key);

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  PageController _pageController;
  int _currentIndex = 0;
  DateTime backButtonPressTime;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  List<Widget> _buildScreens = [
    CanvasViewScreen(navigateFromHomeScreen: false),
    HomeScreen(),
    AllDocsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      headerHeight: MediaQuery.of(context).size.height * 0.30,
      appBar: BackdropAppBar(
        title: Text('Paint to Print'),
        leading: BackdropToggleButton(icon: AnimatedIcons.home_menu),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await _firebaseAuth.signOut();
            },
            icon: Icon(Icons.logout_rounded),
          ),
        ],
      ),
      backLayer: BackLayerMenu(context: context),
      frontLayer: DoubleBackToCloseApp(
        snackBar: SnackBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(18.0))),
          content: Text(
            'Tap back again to exit',
            style: GoogleFonts.arimo(fontSize: 17.0),
          ),
        ),
        child: _buildScreens.elementAt(_currentIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20.0,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300],
              hoverColor: Colors.grey[100],
              gap: 8.0,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
              tabBorderRadius: 20.0,
              tabs: [
                /// home
                GButton(
                  icon: CupertinoIcons.home,
                  text: 'Home',
                  textStyle: GoogleFonts.arimo(
                      fontSize: 17.0, fontWeight: FontWeight.w800),
                  iconColor: Theme.of(context).colorScheme.secondary,
                  backgroundGradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),

                /// canvas
                GButton(
                  icon: MaterialCommunityIcons.draw,
                  text: 'Canvas',
                  textStyle: GoogleFonts.arimo(
                      fontSize: 17.0, fontWeight: FontWeight.w800),
                  iconColor: Color(0xFFDB2B39),
                  backgroundGradient: LinearGradient(
                    colors: [
                      Color(0xFFDB2B39).withOpacity(0.8),
                      Color(0xFFDB2B39).withOpacity(0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),

                /// all docs
                GButton(
                  icon: MdiIcons.fileDocument,
                  text: 'All Docs',
                  textStyle: GoogleFonts.arimo(
                      fontSize: 17.0, fontWeight: FontWeight.w800),
                  iconColor: Color(0xFF344CB7),
                  backgroundGradient: LinearGradient(
                    colors: [
                      Color(0xFF344CB7).withOpacity(0.8),
                      Color(0xFF344CB7).withOpacity(0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ],
              selectedIndex: _currentIndex,
              onTabChange: (index) => setState(() => _currentIndex = index),
            ),
          ),
        ),
      ),
    );
  }
}
