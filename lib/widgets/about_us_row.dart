import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class AboutUsCustomListTile extends StatelessWidget {
  final Widget navigateToScreen;
  final String dp;
  final String name;
  final String bio;
  final String phoneNumber;

  const AboutUsCustomListTile({
    Key key,
    @required this.navigateToScreen,
    @required this.dp,
    @required this.name,
    @required this.bio,
    @required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: navigateToScreen,
          ),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.17,
        padding: EdgeInsets.only(
            top:MediaQuery.of(context).size.height * 0.01,
            left: MediaQuery.of(context).size.width * 0.01,
            right: MediaQuery.of(context).size.width * 0.01),
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(MediaQuery.of(context).size.height * 0.3),
            bottomLeft: Radius.circular(MediaQuery.of(context).size.height * 0.3),
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              color: Colors.black54,
              blurRadius: 20.0,
            ),
          ],
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // dp
            Align(
              alignment: Alignment.centerLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.3),
                child: Image.asset(
                  dp,
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width * 0.23,
                  height: MediaQuery.of(context).size.width * 0.23,
                ),
              ),
            ),
            Flexible(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.015),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // name
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.005),
                          child: AutoSizeText(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: GoogleFonts.arimo(
                              fontSize: MediaQuery.of(context).size.width * 0.07,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      // bio
                      Flexible(
                        child: AutoSizeText(
                          bio,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.arimo(
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      // phoneNumber
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.005),
                          child: TextButton.icon(
                            onPressed: () async {
                              // var url = 'tel:$phoneNumber';
                              // if (await canLaunch(url)) {
                              //   await launch(url);
                              // } else {
                              //   throw 'Could not launch $url';
                              // }
                              await FlutterPhoneDirectCaller.callNumber(phoneNumber);
                            },
                            icon: Icon(Icons.call,size: MediaQuery.of(context).size.height * 0.03,),
                            label: AutoSizeText(
                              phoneNumber,
                              style: GoogleFonts.arimo(
                                fontSize: MediaQuery.of(context).size.width * 0.03,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
