import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsTextFormField extends StatelessWidget {
  final String labelText;
  final String initialValue;
  final int maxLines;

  const AboutUsTextFormField({
    Key key,
    @required this.labelText,
    @required this.initialValue,
    this.maxLines = null,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
      child: TextFormField(
        initialValue: initialValue,
        style: GoogleFonts.arimo(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700,
          fontSize: MediaQuery.of(context).size.width * 0.035,
        ),
        enabled: false,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.arimo(letterSpacing: 0.5),
        ),
        maxLines: maxLines,
        readOnly: true,
      ),
    );
  }
}
