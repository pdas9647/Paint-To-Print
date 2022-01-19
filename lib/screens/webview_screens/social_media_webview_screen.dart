import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SocialMediaWebViewScreen extends StatefulWidget {
  final String assetImage;
  final String title;
  final String url;
  const SocialMediaWebViewScreen({
    Key key,
    @required this.assetImage,
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
        centerTitle: true,
        elevation: 0.0,
        toolbarHeight: MediaQuery.of(context).size.height * 0.10,
        leadingWidth: MediaQuery.of(context).size.width * 0.20,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              child: Image.asset(
                widget.assetImage,
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.width * 0.1,
                width: MediaQuery.of(context).size.width * 0.1,
              ),
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
