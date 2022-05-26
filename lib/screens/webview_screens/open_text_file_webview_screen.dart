
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OpenTextFileWebViewScreen extends StatefulWidget {
  final String url;
  const OpenTextFileWebViewScreen({Key key, this.url}) : super(key: key);

  @override
  _OpenTextFileWebViewScreenState createState() =>
      _OpenTextFileWebViewScreenState();
}

class _OpenTextFileWebViewScreenState extends State<OpenTextFileWebViewScreen> {
  WebViewController webviewController;

  _loadHtmlFromAssets() async {
    webviewController.loadUrl(widget.url
        // , mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString()
    );
  }

  @override
  Widget build(BuildContext context) {
    _loadHtmlFromAssets();
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.url,
              // initialUrl: 'https://rrtutors.com/',
              onWebViewCreated: (WebViewController webViewController) {
                webviewController = webViewController;
                // webviewController.loadUrl(widget.url);
                _loadHtmlFromAssets();
              },
            ),
          ),
        ),
      ),
    );
  }
}
