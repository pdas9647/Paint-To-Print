import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:paint_to_print/services/profile_details_map.dart';
import 'package:paint_to_print/widgets/about_us_row.dart';

import 'individual_profile_screen.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key key}) : super(key: key);

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    print(swagato);

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
                  navigateToScreen:
                      IndividualProfileScreen(personMap: padmanabha),
                  dp: padmanabha['dp'],
                  name: padmanabha['name'],
                  bio: padmanabha['bio'],
                  phoneNumber: padmanabha['phoneNumber'],
                ),

                /// swagato
                AboutUsCustomListTile(
                  navigateToScreen: IndividualProfileScreen(personMap: swagato),
                  dp: swagato['dp'],
                  name: swagato['dp'],
                  bio: swagato['bio'],
                  phoneNumber: swagato['phoneNumber'],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
