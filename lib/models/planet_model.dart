import 'dart:math';

import 'package:flutter/material.dart';
import 'package:planet_social/base/utils.dart';
import 'package:planet_social/models/user_model.dart';

class Planet 
{
  Planet();
  String id;
  String title;
  String ownerId;
  Offset position;
  Color get color => Util.randomColor(key: title);
  User owner;

  Map<String,dynamic> jsonMap(){
    Map<String,dynamic> map = Map();
    map["objectId"] = id;
    map["title"] = title;
    map["ownerId"] = ownerId;
    if(position != null){
map["location"] = [position.dx.toString(),position.dy.toString()].join(",");
    }
    return map;
  }
  factory Planet.withJson(Map<String,dynamic> rawData){
    Planet planet = Planet();
    planet.id = rawData["objectId"];
    planet.title = rawData["title"];
    planet.ownerId = rawData["ownerId"];
    if (rawData["location"] != null){
      List data = rawData["location"].split(",");
      planet.position = Offset(double.parse(data.first), double.parse(data.last));
    }
    
    return planet;
  }
}