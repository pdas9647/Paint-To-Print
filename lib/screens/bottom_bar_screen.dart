import 'package:backdrop/backdrop.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:paint_to_print/screens/all_docs_screen.dart';
import 'package:paint_to_print/services/global_methods.dart';
import 'package:paint_to_print/widgets/back_layer_menu.dart';
import 'package:paint_to_print/widgets/backdrop_toggle_button.dart';

import 'canvas/canvas_view_screen.dart';
import 'home_screen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key key}) : super(key: key);

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen>
    with TickerProviderStateMixin {
  PageController _pageController;
  int _currentIndex = 0;
  DateTime backButtonPressTime;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AnimationController _animationController;
  bool isHome = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  List<Widget> _buildScreens = [
    HomeScreen(),
    CanvasViewScreen(
      isNavigatedFromHomeScreen: false,
      isNavigatedFromPdfImagesScreen: false,
      pdfModel: null,
    ),
    AllDocsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return BackdropScaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      headerHeight: height * 0.30,
      appBar: BackdropAppBar(
        title: Text(
          'Paint to Print',
          style: GoogleFonts.satisfy(fontSize: width * 0.07),
        ),
        toolbarHeight: height * 0.10,
        leadingWidth: width * 0.20,
        leading: CustomBackdropToggleButton(icon: AnimatedIcons.home_menu),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          Transform.scale(
            scale: 1.5,
            child: Container(
              width: width * 0.20,
              // color: Colors.redAccent,
              child: IconButton(
                // color: Colors.redAccent,
                onPressed: () async {
                  GlobalMethods.signOutDialog(
                      context, 'Warning!', 'Do you want to logout?');
                },
                icon: Icon(Icons.logout_rounded, size: height * 0.03),
              ),
            ),
          ),
          // SizedBox(width: width * 0.015),
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
        height: height * 0.09,
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
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: height * 0.015),
            child: GNav(
              rippleColor: Colors.grey[300],
              hoverColor: Colors.grey[100],
              gap: width * 0.10,
              // iconSize: 40,
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05, vertical: height * 0.01),
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
              tabBorderRadius: 20.0,
              tabs: [
                /// home
                GButton(
                  icon: CupertinoIcons.home,
                  iconSize: width * 0.6,
                  gap: width * 0.10,
                  text: 'Home',
                  textStyle: GoogleFonts.arimo(
                      fontSize: width * 0.5, fontWeight: FontWeight.w800),
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
                  iconSize: width * 0.6,
                  gap: width * 0.10,
                  text: 'Canvas',
                  textStyle: GoogleFonts.arimo(
                      fontSize: width * 0.5, fontWeight: FontWeight.w800),
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
                  iconSize: width * 0.6,
                  gap: width * 0.10,
                  text: 'All Docs',
                  textStyle: GoogleFonts.arimo(
                      fontSize: width * 0.5, fontWeight: FontWeight.w800),
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
