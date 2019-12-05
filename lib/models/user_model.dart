import 'dart:math';
import 'package:flutter/material.dart';

class User {
  String avatar = "https://b-ssl.duitang.com/uploads/item/201609/04/20160904213235_eLHmW.jpeg";
  String nickName = "Francisco Maia";
  List<String> tags = ["标签1","标签2","标签3"];
  int fans = 12312;
  int like = 12323;
  int sex = 1;
  final Offset position = Offset(Random().nextDouble()*2000-1000,Random().nextDouble()*2000-1000);
}