import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';

class User {

  User();

  String avatar = "https://b-ssl.duitang.com/uploads/item/201609/04/20160904213235_eLHmW.jpeg";
  String nickName = "Francisco_Maia";
  List<String> tags = ["标签1","标签2","标签3"];
  int fans = 12312;
  int like = 12323;
  int sex = 1;
  Offset position = Offset(Random().nextDouble()*2000-1000,Random().nextDouble()*2000-1000);
  String phone = "13811111111";
  String userId;
  String sessionToken;
  String plannetId;
  Map<String,dynamic> rawJson;

  Map<String,dynamic> jsonMap(){
    Map<String,dynamic> map = Map();
    map["avatar"] = avatar;
    map["username"] = nickName;
    map["tags"] = tags.join(",");
    map["fans"] = fans.toString();
    map["like"] = like.toString();
    map["sex"] = sex.toString();
    map["phoneNumber"] = phone;
    map["objectId"] = userId;
    map["sessionToken"] = sessionToken;
    map["plannetId"] = plannetId;
    return map;
  }

  factory User.withJson(Map<String,String> rawData){
    User user = User();
    user.avatar = rawData["avatar"];
    user.nickName = rawData["username"];
    user.tags = (rawData["tags"] as String).split(",");
    user.fans = int.parse(rawData["fans"]);
    user.like = int.parse(rawData["like"]);
    user.sex = int.parse(rawData["sex"]);
    user.phone = rawData["phoneNumber"];
    user.userId = rawData["objectId"];
    user.sessionToken = rawData["ij8i69l1dijfot062rgk18b12"];
    user.plannetId = rawData["plannetId"];
    return user;
  }
}

