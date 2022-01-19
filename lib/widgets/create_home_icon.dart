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
    this.iconName,
    this.image,
    this.shadowColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10.0,
        shadowColor: shadowColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          // padding: EdgeInsets.symmetric(
          //     horizontal: MediaQuery.of(context).size.width * 0.01,
          //     vertical: MediaQuery.of(context).size.width * 0.01),
          width: MediaQuery.of(context).size.width * 0.46,
          height: MediaQuery.of(context).size.height * 0.25,
          color: Colors.indigo,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                // color: Colors.lightGreenAccent,
                width: MediaQuery.of(context).size.width * 0.30,
                height: MediaQuery.of(context).size.width * 0.30,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Flexible(
                child: AutoSizeText(
                  iconName,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.arimo(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
