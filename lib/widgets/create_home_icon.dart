import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateHomeIcon extends StatelessWidget {
  final String iconName;
  final IconData iconData;
  final Color shadowColor;
  final Function() onTap;
  const CreateHomeIcon({
    Key key,
    this.iconName,
    this.iconData,
    this.shadowColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 10.0,
          shadowColor: shadowColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Container(
            padding: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 5,
                  child: Icon(
                    iconData,
                    size: 80.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 10.0),
                AutoSizeText(
                  iconName,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.courgette(fontSize: 20.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
