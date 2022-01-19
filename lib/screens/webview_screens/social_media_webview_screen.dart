import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SocialMediaWebViewScreen extends StatefulWidget {
  final IconData iconData;
  final String title;
  final String url;

  const SocialMediaWebViewScreen({
    Key key,
    @required this.iconData,
    @required this.title,
    @required this.url,
  }) : super(key: key);

  @override
  _SocialMediaWebViewScreenState createState() =>
      _SocialMediaWebViewScreenState();
}

class _SocialMediaWebViewScreenState extends State<SocialMediaWebViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        elevation: 0.0,
        toolbarHeight: MediaQuery.of(context).size.height * 0.10,
        leadingWidth: MediaQuery.of(context).size.width * 0.10,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_rounded),
          iconSize: MediaQuery.of(context).size.width * 0.06,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              child: Icon(widget.iconData,size: MediaQuery.of(context).size.width * 0.08,),
            ),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              child: AutoSizeText(
                widget.title,
                style: GoogleFonts.arimo(
                  fontSize: MediaQuery.of(context).size.width * 0.07,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: widget.url,
        ),
      ),
    );
  }
}
