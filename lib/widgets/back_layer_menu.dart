import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint_to_print/screens/about_us_screen.dart';
import 'package:paint_to_print/screens/onboarding_screen.dart';

class BackLayerMenu extends StatelessWidget {
  final BuildContext context;
  const BackLayerMenu({Key key, this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        Positioned(
          top: -100.0,
          left: 140.0,
          child: Transform.rotate(
            angle: -0.5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white.withOpacity(0.3),
              ),
              width: 150.0,
              height: 250.0,
            ),
          ),
        ),
        Positioned(
          bottom: 0.0,
          right: 100.0,
          child: Transform.rotate(
            angle: -0.8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white.withOpacity(0.3),
              ),
              width: 150.0,
              height: 300.0,
            ),
          ),
        ),
        Positioned(
          top: -50.0,
          left: 60.0,
          child: Transform.rotate(
            angle: -0.5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white.withOpacity(0.3),
              ),
              width: 150.0,
              height: 200.0,
            ),
          ),
        ),
        Positioned(
          bottom: 10.0,
          right: 0.0,
          child: Transform.rotate(
            angle: -0.8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white.withOpacity(0.3),
              ),
              width: 150.0,
              height: 300.0,
            ),
          ),
        ),
        Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),

            /// app_icon
            Center(
              child: Container(
                height: 150.0,
                width: 150.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage('assets/images/app_icon_without_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),

            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              child: ListView(
                shrinkWrap: true,
                children: [
                  /// getting started
                  backLayerCreateItem(
                    buildContext: context,
                    itemName: 'Getting Started',
                    iconData: Icons.category_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: OnBoardingScreen(),
                          type: PageTransitionType.fade,
                        ),
                      );
                    },
                  ),

                  /// help
                  backLayerCreateItem(
                    buildContext: context,
                    itemName: 'Help',
                    iconData: Icons.help_center_rounded,
                    onTap: () {
                      /// navigate to help screen
                      // Navigator.push(
                      //   context,
                      //   PageTransition(
                      //     child: OnBoardingScreen(),
                      //     type: PageTransitionType.fade,
                      //   ),
                      // );
                    },
                  ),

                  /// about us
                  backLayerCreateItem(
                    buildContext: context,
                    itemName: 'About Us',
                    iconData: Icons.info_outline_rounded,
                    onTap: () {
                      /// navigate to about us screen
                      Navigator.push(
                        context,
                        PageTransition(
                          child: AboutUsScreen(),
                          type: PageTransitionType.fade,
                        ),
                      );
                    },
                  ),

                  /// rate us
                  backLayerCreateItem(
                    buildContext: context,
                    itemName: 'Rate Us',
                    iconData: Icons.star_rate,
                    onTap: () {
                      /// open app in playstore
                      // Navigator.push(
                      //   context,
                      //   PageTransition(
                      //     child: OnBoardingScreen(),
                      //     type: PageTransitionType.fade,
                      //   ),
                      // );
                    },
                  ),

                  /// invite friend to paint to print
                  backLayerCreateItem(
                    buildContext: context,
                    itemName: 'Invite Friend to Paint to Print',
                    iconData: Icons.share_rounded,
                    onTap: () {
                      /// share playstore app link
                      // Navigator.push(
                      //   context,
                      //   PageTransition(
                      //     child: OnBoardingScreen(),
                      //     type: PageTransitionType.fade,
                      //   ),
                      // );
                    },
                  ),
                  // SizedBox(height: MediaQuery.of(context).size.height * 0.30),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget backLayerCreateItem({
  BuildContext buildContext,
  String itemName,
  IconData iconData,
  Function onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconData),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AutoSizeText(
            itemName,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: GoogleFonts.arimo(
              fontSize: 17.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}
