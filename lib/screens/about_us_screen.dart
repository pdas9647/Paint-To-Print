import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:paint_to_print/widgets/about_us_row.dart';

import 'swagato_profile_screen.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key key}) : super(key: key);

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: size.height * 0.50,
            width: size.width,
            // color: Colors.pinkAccent,
            alignment: Alignment.bottomCenter,
            child: Image.asset('assets/images/app_icon_without_bg.png'),
          ),
          Container(
            height: size.height * 0.50,
            width: size.width,
            // color: Colors.greenAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// padmanabha
                AboutUsCustomListTile(
                  navigateToScreen: SwagatoProfileScreen(),
                  dp: 'assets/images/padmanabha.png',
                  name: 'Padmanabha Das',
                  bio: 'Android & Flutter Developer, QA Analyst, Experienced in Web Development',
                  phoneNumber: '9647100133',
                ),

                /// swagato
                AboutUsCustomListTile(
                  navigateToScreen: SwagatoProfileScreen(),
                  dp: 'assets/images/swagato.jpg',
                  name: 'Swagato Bag',
                  bio:
                      'Competitive Programmer, Passionate Singer, Acoustic Guitar Player',
                  phoneNumber: '8670513077',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
