import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paint_to_print/services/global_methods.dart';
import 'package:paint_to_print/widgets/about_us_social_media_icon.dart';
import 'package:paint_to_print/widgets/about_us_textformfield.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

class SwagatoProfileScreen extends StatefulWidget {
  const SwagatoProfileScreen({Key key}) : super(key: key);

  @override
  _SwagatoProfileScreenState createState() => _SwagatoProfileScreenState();
}

class _SwagatoProfileScreenState extends State<SwagatoProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          // backgroundColor: Colors.transparent,
                          elevation: 8.0,
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    minHeight: 100.0,
                                    maxHeight: size.height * 0.50,
                                  ),
                                  width: double.infinity,
                                  child: Image.asset(
                                    'assets/images/swagato.jpg',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Text(
                                  'Swagato Bag',
                                  style: GoogleFonts.arimo(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: Container(
                  height: size.width * 0.9,
                  width: size.width,
                  child: Image.asset(
                    'assets/images/swagato.jpg',
                    fit: BoxFit.fill,
                    width: size.width * 0.45,
                    height: size.height * 0.15,
                  ),
                ),
              ),
              Spacer(),
              Container(
                // height: size.height * 0.2,
                // decoration: BoxDecoration(
                //   borderRadius:
                //       BorderRadius.vertical(top: Radius.circular(30.0)),
                //   color: Colors.teal.shade200,
                // ),
              ),
              Container(
                height: size.height * 0.15,
                width: size.width * 0.7,
                // color: Colors.pink,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// facebook
                    AboutUsSocialMediaIcon(
                      // iconData: MaterialCommunityIcons.facebook_box,
                      // color: Color(0xFF1773EA),
                      image: 'assets/images/facebook_icon.png',
                      onTap: () async {
                        await GlobalMethods.launchURL(
                            url: 'https://www.facebook.com/swagato.bag.7');
                      },
                    ),

                    /// instagram
                    AboutUsSocialMediaIcon(
                      // iconData: MaterialCommunityIcons.instagram,
                      image: 'assets/images/instagram_icon.png',
                      onTap: () async {
                        await GlobalMethods.launchURL(
                            url: 'https://www.instagram.com/swagato.bag/');
                      },
                    ),

                    /// linked in
                    AboutUsSocialMediaIcon(
                      // iconData: MaterialCommunityIcons.linkedin_box,
                      // color: Color(0xFF0077B5),
                      image: 'assets/images/linkedin_icon.png',
                      onTap: () async {
                        await GlobalMethods.launchURL(
                            url: 'https://www.linkedin.com/in/swagatobag/');
                      },
                    ),

                    /// github
                    AboutUsSocialMediaIcon(
                      // iconData: MaterialCommunityIcons.github_circle,
                      image: 'assets/images/github_icon.png',
                      onTap: () async {
                        await GlobalMethods.launchURL(
                            url: 'https://github.com/swagatobag2000');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: size.height * 0.40,
            left: size.width * 0.10,
            right: size.width * 0.10,
            bottom: size.height * 0.15,
            child: Container(
              width: size.width,
              // height: size.height * 0.8,
              padding: EdgeInsets.only(bottom: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(5, 10),
                    color: Colors.black54,
                    blurRadius: 20.0,
                  ),
                ],
              ),
              child: Form(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: AutoSizeText(
                        'GET IN TOUCH!',
                        style: GoogleFonts.arimo(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.w700,
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                        ),
                      ),
                    ),

                    /// name
                    AboutUsTextFormField(
                      labelText: 'Name',
                      initialValue: 'Swagato Bag',
                      maxLines: 1,
                    ),

                    /// email
                    AboutUsTextFormField(
                      labelText: 'Email',
                      initialValue: 'swagatobag23@gmail.com',
                    ),

                    /// phone
                    AboutUsTextFormField(
                      labelText: 'Phone',
                      initialValue: '8670513077',
                    ),

                    /// message
                    AboutUsTextFormField(
                      labelText: 'Bio',
                      initialValue:
                          'Passionate to Get My Hands Dirty Over Whatever Technology Possible | Competitive Programmer | Tech Enthusiast | Passionate Singer | Acoustic Guitar Player |',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
