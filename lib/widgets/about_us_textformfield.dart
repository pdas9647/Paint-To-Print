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
    return TextFormField(
      initialValue: initialValue,
      style: GoogleFonts.arimo(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w700,
      ),
      enabled: false,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.arimo(letterSpacing: 0.5),
      ),
      maxLines: maxLines,
      readOnly: true,
    );
  }
}
