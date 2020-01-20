import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planet_social/const.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

    return MaterialApp(
      title: Consts.name,
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.white),
          primarySwatch: Colors.blue,
          fontFamily: Platform.isIOS ? 'PingFang SC' : null),
      home: PlanetSocial(),
    );
  }
}
