import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:paint_to_print/screens/webview_screens/social_media_webview_screen.dart';
import 'package:paint_to_print/widgets/about_us_social_media_icon.dart';
import 'package:paint_to_print/widgets/about_us_textformfield.dart';

class IndividualProfileScreen extends StatefulWidget {
  final Map<String, String> personMap;

  const IndividualProfileScreen({Key key, @required this.personMap})
      : super(key: key);

  @override
  _IndividualProfileScreenState createState() =>
      _IndividualProfileScreenState();
}

class _IndividualProfileScreenState extends State<IndividualProfileScreen> {
  Map<String, String> personMap;

  Future<void> showNoMailAppsDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Open Mail App'),
          content: Text('No mail apps installed'),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    personMap = widget.personMap;
  }

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
                                    personMap['dp'],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  personMap['name'],
                                  style: GoogleFonts.arimo(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: size.height * 0.05,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: Container(
                  height: size.width,
                  width: size.width,
                  child: Image.asset(
                    personMap['dp'],
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
                        print(personMap['facebook']);
                        // await GlobalMethods.launchURL(url: personMap['facebook']
                        // 'https://www.facebook.com/swagato.bag.7'
                        // );
                        Navigator.push(
                          context,
                          PageTransition(
                            child: SocialMediaWebViewScreen(
                              iconData: Icons.facebook_rounded,
                              title: 'Facebook',
                              url: personMap['facebook'],
                            ),
                            type: PageTransitionType.slideInLeft,
                            duration: Duration(milliseconds: 5),
                          ),
                        );
                      },
                    ),

                    /// instagram
                    AboutUsSocialMediaIcon(
                      // iconData: MaterialCommunityIcons.instagram,
                      image: 'assets/images/instagram_icon.png',
                      onTap: () async {
                        // await GlobalMethods.launchURL(
                        //     url: personMap['instagram']);
                        Navigator.push(
                          context,
                          PageTransition(
                            child: SocialMediaWebViewScreen(
                              iconData: FontAwesome.instagram,
                              title: 'Instagram',
                              url: personMap['instagram'],
                            ),
                            type: PageTransitionType.slideInRight,
                            duration: Duration(milliseconds: 5),
                          ),
                        );
                      },
                    ),

                    /// linkedin
                    AboutUsSocialMediaIcon(
                      // iconData: MaterialCommunityIcons.linkedin_box,
                      // color: Color(0xFF0077B5),
                      image: 'assets/images/linkedin_icon.png',
                      onTap: () async {
                        // await GlobalMethods.launchURL(
                        //     url: personMap['linkedIn']);
                        Navigator.push(
                          context,
                          PageTransition(
                            child: SocialMediaWebViewScreen(
                              iconData: FontAwesome.linkedin_square,
                              title: 'LinkedIn',
                              url: personMap['linkedIn'],
                            ),
                            type: PageTransitionType.slideInLeft,
                            duration: Duration(milliseconds: 5),
                          ),
                        );
                      },
                    ),

                    /// github
                    AboutUsSocialMediaIcon(
                      // iconData: MaterialCommunityIcons.github_circle,
                      image: 'assets/images/github_icon.png',
                      onTap: () async {
                        // await GlobalMethods.launchURL(url: personMap['github']);
                        Navigator.push(
                          context,
                          PageTransition(
                            child: SocialMediaWebViewScreen(
                              iconData: FontAwesome.github,
                              title: 'GitHub',
                              url: personMap['github'],
                            ),
                            type: PageTransitionType.slideInRight,
                            duration: Duration(milliseconds: 5),
                          ),
                        );
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
                      initialValue: personMap['name'],
                      maxLines: 1,
                    ),

                    /// email
                    AboutUsTextFormField(
                      labelText: 'Email',
                      initialValue: personMap['email'],
                      onTap: () async {
                        print('Email');
                        EmailContent emailContent = EmailContent(
                          to: [personMap['email']],
                          subject: 'Hello!',
                          body: 'How are you doing?',
                          // cc: ['user2@domain.com', 'user3@domain.com'],
                          // bcc: ['boss@domain.com'],
                        );
                        var apps = await OpenMailApp.getMailApps();
                        // If no mail apps found, show error
                        if (apps.isEmpty) {
                          showNoMailAppsDialog(context);
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return MailAppPickerDialog(
                                mailApps: apps,
                                emailContent: emailContent,
                              );
                            },
                          );
                        }
                      },
                    ),

                    /// phone
                    AboutUsTextFormField(
                      labelText: 'Phone',
                      initialValue: personMap['phoneNumber'],
                      onTap: () async {
                        print('Phone');
                        await FlutterPhoneDirectCaller.callNumber(
                            personMap['phoneNumber']);
                      },
                    ),

                    /// message
                    AboutUsTextFormField(
                      labelText: 'Bio',
                      initialValue: personMap['bio_long'],
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
