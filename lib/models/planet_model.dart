import 'dart:math';

import 'package:flutter/material.dart';
import 'package:planet_social/base/utils.dart';
import 'package:planet_social/models/user_model.dart';

class Planet 
{
  Planet();
  String id;
 String title = "某某兴趣星球";
 User owner = User();
  String ownerId;
 int fans = 122234;
 String location;
 Offset position = Offset(Random().nextDouble()*2000-1000,Random().nextDouble()*2000-1000);
 Color color = Util.randomColor();

  Map<String,dynamic> jsonMap(){
    Map<String,dynamic> map = Map();
    map["objectId"] = id;
    map["title"] = title;
    map["ownerId"] = ownerId;
    map["fans"] = fans.toString();
    map["location"] = location;
    // map["color"] = color.toString();
    return map;
  }
  factory Planet.withJson(Map<String,String> rawData){
    Planet planet = Planet();
    planet.id = rawData["objectId"];
    planet.title = rawData["title"];
    planet.ownerId = rawData["ownerId"];
    planet.fans = int.parse(rawData["fans"]);
    planet.location = rawData["location"];
    // planet.color = rawData["color"];
    return planet;
  }
}