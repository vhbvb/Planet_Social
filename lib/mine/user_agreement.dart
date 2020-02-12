import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planet_social/route.dart';
import 'package:webview_flutter/webview_flutter.dart';
 
class AgreementPage extends StatefulWidget {
 @override
 _AgreementPageState createState() => _AgreementPageState();
}
 
class _AgreementPageState extends State<AgreementPage> {
 WebViewController _webViewController;
 String filePath = 'assets/agreement.html';
 
 @override
 Widget build(BuildContext context) {
  return Scaffold(
    
   appBar: AppBar(title: Text('用户协议',style: TextStyle(fontSize: 17.0, color: Colors.black)),
   leading: GestureDetector(
                  onTap: () {
                    PSRoute.pop(context);
                  },
                  child: Padding(
                    child: Image.asset(
                      "assets/back.png",
                    ),
                    padding: EdgeInsets.all(11),
                  ),
                ),),
   body: WebView(
    initialUrl: '',
    javascriptMode: JavascriptMode.unrestricted,
    onWebViewCreated: (WebViewController webViewController) {
     _webViewController = webViewController;
     _loadHtmlFromAssets();
    },
   )
  );
 }
 
  _loadHtmlFromAssets() async {
  String fileHtmlContents = await rootBundle.loadString(filePath);
  _webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
      mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
    .toString());
 }
}