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
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        margin: EdgeInsets.only(left: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60.0),
            bottomLeft: Radius.circular(60.0),
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // dp
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.asset(
                dp,
                fit: BoxFit.fill,
                width: 100.0,
                height: 100.0,
              ),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // name
                    AutoSizeText(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: GoogleFonts.arimo(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    // bio
                    AutoSizeText(
                      bio,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.arimo(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    // phoneNumber
                    TextButton.icon(
                      onPressed: () async {
                        var url = 'tel:$phoneNumber';
                        // if (await canLaunch(url)) {
                        //   await launch(url);
                        // } else {
                        //   throw 'Could not launch $url';
                        // }
                        await FlutterPhoneDirectCaller.callNumber(phoneNumber);
                      },
                      icon: Icon(Icons.call),
                      label: AutoSizeText(
                        phoneNumber,
                        style: GoogleFonts.arimo(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
