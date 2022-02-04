import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateHomeIcon extends StatelessWidget {
  final double width;
  final double height;
  final String iconName;
  final String image;
  final double imageSize;
  final Color shadowColor;
  final Function() onTap;

  const CreateHomeIcon({
    Key key,
    @required this.width,
    @required this.height,
    @required this.iconName,
    @required this.image,
    @required this.imageSize,
    this.shadowColor = Colors.transparent,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.height * 0.03)),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.lightBlue.shade50,
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
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                fit: BoxFit.cover,
                width: imageSize,
                height: imageSize,
              ),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              AutoSizeText(
                iconName,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: GoogleFonts.arimo(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.height * 0.04,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
