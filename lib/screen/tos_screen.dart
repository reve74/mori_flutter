import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TosScreen extends StatefulWidget {
  const TosScreen({Key? key}) : super(key: key);

  @override
  State<TosScreen> createState() => _TosScreenState();
}

class _TosScreenState extends State<TosScreen> {
  WebViewController? controller;

  final homeUrl = 'https://docs.google.com/forms/d/1HJL5exwkcTuGHbFqSF7xQF8JyZuSiGLjacXR4eK9JeE/edit';

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          '이용 약관',
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebView(
            onWebViewCreated: (WebViewController controller) {
              this.controller = controller;
            },
            initialUrl: homeUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading ? const Center(child: CircularProgressIndicator()) : Stack()
        ],
      ),
    );
  }
}
