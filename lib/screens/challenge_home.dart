import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacha/globals.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChallengeHome extends StatefulWidget {
  const ChallengeHome({Key? key}) : super(key: key);
  @override
  _ChallengeHomeState createState() => _ChallengeHomeState();
}

class _ChallengeHomeState extends State<ChallengeHome> with AutomaticKeepAliveClientMixin<ChallengeHome> {
  @override
  bool get wantKeepAlive => true;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS) {
      return WebView(
        initialUrl: Globals.challenge!.homepageUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('${Globals.challenge!.homepageUrl}')) {
            return NavigationDecision.navigate;
          } else {
            _launchURL(request.url);
            return NavigationDecision.prevent;
          }
        },
      );
    }
    return Container();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
