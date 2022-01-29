import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFileViewerScreen extends StatefulWidget {
  final String fileContent;

  const TextFileViewerScreen({Key key, this.fileContent}) : super(key: key);

  @override
  _TextFileViewerScreenState createState() => _TextFileViewerScreenState();
}

class _TextFileViewerScreenState extends State<TextFileViewerScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        // color: Colors.yellowAccent.shade100,
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.05,
        ),
        child: SingleChildScrollView(
          child: Text(
            widget.fileContent,
            style: GoogleFonts.arimo(
              fontWeight: FontWeight.w400,
              fontSize: height * 0.025,
            ),
          ),
        ),
      ),
    );
  }
}
