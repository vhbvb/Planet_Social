import 'dart:math';
import 'package:flutter/material.dart';

class User {
  User();

  int fans;
  int like;

  String avatar;
  String nickName;
  String userName;
  List<String> tags;
  int sex;
  Offset position = Offset(
      Random().nextDouble() * 2000 - 1000, Random().nextDouble() * 2000 - 1000);
  String phone;
  String userId;
  String sessionToken;
  Map authData;
  String imToken;

  Map<String, dynamic> jsonMap() {
    Map<String, dynamic> map = Map();
    map["avatar"] = avatar;
    map["username"] = userName;
    map["nickname"] = nickName;
    if (tags != null) {
      map["tags"] = tags.join(",");
    }
    map["fans"] = fans;
    map["like"] = like;
    map["sex"] = sex;
    map["phoneNumber"] = phone;
    map["objectId"] = userId;
    map["sessionToken"] = sessionToken;
    // map["plannetId"] = plannetId;
    map.removeWhere((key, value) {
      return value == null;
    });
    map["authData"] = authData;
    map["imToken"] = imToken;
    map.removeWhere((key, value) {
      return value == null || value == "null";
    });
    return map;
  }

  factory User.withJson(Map<String, dynamic> rawData) {
    User user = User();
    user.avatar = rawData["avatar"];
    user.nickName = rawData["nickname"];
    user.userName = rawData["username"];
    if (rawData["tags"] != null) {
      user.tags = (rawData["tags"] as String).split(",");
    }
    user.fans = rawData["fans"];
    user.like = rawData["like"];
    user.sex = rawData["sex"];
    user.phone = rawData["phoneNumber"];
    user.userId = rawData["objectId"];
    user.sessionToken = rawData["sessionToken"];
    // user.plannetId = rawData["plannetId"];
    user.authData = rawData["authData"];
    user.imToken = rawData["imToken"];
    // user.rawJson = rawData;
    return user;
  }
}
