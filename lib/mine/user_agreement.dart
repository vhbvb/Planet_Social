import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planet_social/base/manager.dart';
import 'package:planet_social/route.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AgreementPage extends StatefulWidget {
  bool isReg;
  AgreementPage({Key key, this.isReg = false}) : super(key: key);
  @override
  _AgreementPageState createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  WebViewController _webViewController;
  String filePath = 'assets/agreement.html';

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: Text('用户协议',
              style: TextStyle(fontSize: 17.0, color: Colors.black)),
          leading: widget.isReg?null:GestureDetector(
            onTap: () {
              PSRoute.pop(context);
            },
            child: Padding(
              child: Image.asset(
                "assets/back.png",
              ),
              padding: EdgeInsets.all(11),
            ),
          ),
          actions: widget.isReg?<Widget>[
            MaterialButton(onPressed: (){
              PSRoute.push(context, "user_settings", PSManager.shared.currentUser, replace: true);
            },
            child: Text('同意并继续',
              style: TextStyle(fontSize: 15.0, color: Color(0xffFF8367))))
          ]:null
        ),
        body: WebView(
          initialUrl: '',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController = webViewController;
            _loadHtmlFromAssets();
          },
        ));
  }

  _loadHtmlFromAssets() async {
    String fileHtmlContents = await rootBundle.loadString(filePath);
    _webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
