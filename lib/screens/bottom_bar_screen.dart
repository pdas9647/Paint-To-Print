import 'package:backdrop/backdrop.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:paint_to_print/screens/all_docs.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../main.dart';
import 'canvas/canvas_view_screen.dart';
import 'home_screen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key key}) : super(key: key);

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  PersistentTabController _persistentTabController;
  bool _hideNavBar;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _persistentTabController = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      CanvasViewScreen(),
      AllDocsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ('Home'),
        activeColorPrimary: Color(0xFFF3A712),
        inactiveColorPrimary: Theme.of(context).disabledColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MaterialCommunityIcons.draw),
        title: ('Canvas'),
        activeColorPrimary: Color(0xFFDB2B39),
        inactiveColorPrimary: Theme.of(context).disabledColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.fileDocument),
        title: ('All Docs'),
        activeColorPrimary: Color(0xFF344CB7),
        inactiveColorPrimary: Theme.of(context).disabledColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      headerHeight: MediaQuery.of(context).size.height * 0.45,
      resizeToAvoidBottomInset: false,
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
      backLayer: Center(
        child: Text('Back Layer'),
      ),
      frontLayer: DoubleBackToCloseApp(
        snackBar: SnackBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(18.0))),
          content: Text(
            'Tap back again to exit',
            style: GoogleFonts.courgette(fontSize: 17.0),
          ),
        ),
        child: PersistentTabView(
          context,
          controller: _persistentTabController,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          navBarStyle: NavBarStyle.style9,
          backgroundColor: Colors.white,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          hideNavigationBarWhenKeyboardShows: true,
          itemAnimationProperties: ItemAnimationProperties(
            curve: Curves.easeInToLinear,
            duration: Duration(milliseconds: 500),
          ),
          screenTransitionAnimation: ScreenTransitionAnimation(
            animateTabTransition: true,
            curve: Curves.elasticInOut,
            duration: Duration(milliseconds: 500),
          ),
          navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
              ? 0.0
              : kBottomNavigationBarHeight,
          margin: EdgeInsets.all(0.0),
          popActionScreens: PopActionScreensType.all,
          bottomScreenMargin: 0.0,
          hideNavigationBar: _hideNavBar,
          decoration: NavBarDecoration(
              colorBehindNavBar: Colors.indigo,
              borderRadius: BorderRadius.circular(20.0)),
          popAllScreensOnTapOfSelectedTab: true,
          selectedTabScreenContext: (context) {
            testContext = context;
          },
        ),
      ),
    );
  }
}
