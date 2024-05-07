import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<dynamic> buildModalAbout(
    BuildContext context, WebViewController controller) {
  return showModalBottomSheet(
      backgroundColor: Colors.white,
      showDragHandle: true,
      enableDrag: false, //allows scrolling of the WebView.
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: WebViewWidget(
            controller: controller,
          ),
        );
      });
}
