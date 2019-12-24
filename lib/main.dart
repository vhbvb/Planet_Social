import 'dart:io';

import 'package:flutter/material.dart';
import 'package:planet_social/const.dart';
import 'home.dart';

void main() => runApp(MyApp());

// void main() {
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//     .then((_) {
//       runApp(MyApp());
//     });
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Consts.name,
      color: Colors.white,
      showPerformanceOverlay: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.white),
        primarySwatch: Colors.blue,
        fontFamily: Platform.isIOS ? 'PingFang SC' : null
      ),
      home: PlanetSocial(),
    );
  }
}