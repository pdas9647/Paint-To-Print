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
      backgroundColor: Theme.of(context).backgroundColor,
      extendBody: true,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SafeArea(
                child: Flexible(
                  // profile image
                  child: GestureDetector(
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
                                        'assets/images/swagato.png',
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
                      height: size.height * 0.35,
                      child: WidgetCircularAnimator(
                        outerColor: Theme.of(context).primaryColorDark,
                        innerColor: Theme.of(context).primaryColorDark,
                        innerAnimation: Curves.easeOutExpo,
                        child: Container(
                          width: size.width * 0.50,
                          height: size.height * 0.20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Image.asset(
                              'assets/images/swagato.png',
                              fit: BoxFit.fill,
                              width: size.width * 0.45,
                              height: size.height * 0.15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: size.height * 0.45,
                // decoration: BoxDecoration(
                //   borderRadius:
                //       BorderRadius.vertical(top: Radius.circular(30.0)),
                //   color: Colors.teal.shade200,
                // ),
              ),
              Flexible(
                child: Container(
                  height: size.height * 0.30,
                  width: size.width - size.width * 0.30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      child: Text(
                        'GET IN TOUCH!',
                        style: GoogleFonts.arimo(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 25.0,
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

                    /// message
                    AboutUsTextFormField(
                      labelText: 'Message',
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
