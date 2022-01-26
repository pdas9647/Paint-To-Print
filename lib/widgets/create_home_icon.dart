import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateHomeIcon extends StatelessWidget {
  final String iconName;
  final String image;
  final Color shadowColor;
  final Function() onTap;

  const CreateHomeIcon({
    Key key,
    @required this.iconName,
    @required this.image,
    this.shadowColor = Colors.transparent,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        // elevation: 15.0,
        // shadowColor: shadowColor,
        // color: Colors.yellowAccent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.height * 0.03)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.height * 0.03),
            boxShadow: [
              BoxShadow(
                offset: Offset(5, 25),
                color: shadowColor,
                blurRadius: 40.0,
                spreadRadius: 0.05,
                blurStyle: BlurStyle.normal,
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03,
              vertical: MediaQuery.of(context).size.height * 0.01),
          width: MediaQuery.of(context).size.width * 0.46,
          // height: MediaQuery.of(context).size.height * 0.25,
          // color: Colors.indigo,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                fit: BoxFit.cover,
                // color: Colors.lightGreenAccent,
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.width * 0.25,
              ),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              AutoSizeText(
                iconName,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: GoogleFonts.arimo(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.height * 0.035,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
