import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class TextFileViewerScreen extends StatefulWidget {
  final String textName;
  final String fileContent;

  const TextFileViewerScreen({Key key, this.textName, this.fileContent})
      : super(key: key);

  @override
  _TextFileViewerScreenState createState() => _TextFileViewerScreenState();
}

class _TextFileViewerScreenState extends State<TextFileViewerScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.textName,
          style: GoogleFonts.arimo(
            fontSize: width * 0.05,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: Container(
        // color: Colors.yellowAccent.shade100,
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.05,
        ),
        child: SingleChildScrollView(
          child:
              // Text(
              //   widget.fileContent,
              //   style: GoogleFonts.arimo(
              //     fontWeight: FontWeight.w400,
              //     fontSize: height * 0.025,
              //   ),
              // ),
              SelectableLinkify(
            onOpen: (link) async {
              if (await canLaunch(link.url)) {
                await launch(link.url);
              } else {
                throw 'Could not launch $link';
              }
            },
            text: widget.fileContent,
            style: GoogleFonts.arimo(),
            linkStyle: GoogleFonts.arimo(color: Colors.blueAccent),
          ),
        ),
      ),
    );
  }
}
