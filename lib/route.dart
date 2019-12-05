import 'package:flutter/material.dart';
import 'package:planet_social/explore/explore.dart';
import 'package:planet_social/message/message.dart';
import 'package:planet_social/mine/user_detail.dart';
import 'package:planet_social/mine/user_info.dart';
import 'package:planet_social/planet/my_planet.dart';

class PSRoute {

  static final explore = Explore();
  static final myPlanet = MyPlanet();
  static final message = Message();
  static final me = UserDetail();

  static Widget _page(String url,dynamic params){

    switch (url) {
      case "user_settings":
          return UserInfo(user: params,);
        break;
      default:return Message();
    }
  }

  static push(BuildContext context,String url,dynamic params){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>_page(url, params)));
  }

  static pop(BuildContext context){
    Navigator.of(context).pop();
  }
}