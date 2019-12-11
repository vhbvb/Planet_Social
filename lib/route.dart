import 'package:flutter/material.dart';
import 'package:planet_social/common/login.dart';
import 'package:planet_social/explore/explore.dart';
import 'package:planet_social/message/message.dart';
import 'package:planet_social/mine/user_detail.dart';
import 'package:planet_social/mine/user_info.dart';
import 'package:planet_social/mine/user_tags.dart';
import 'package:planet_social/planet/my_planet.dart';
import 'package:planet_social/planet/planet_detail.dart';
import 'package:planet_social/planet/post_content.dart';
import 'package:planet_social/planet/post_post.dart';

class PSRoute {
  static final explore = Explore();
  static final myPlanet = MyPlanet();
  static final message = Message();
  static final me = UserDetail();

  static Widget _page(String url,dynamic params){

    switch (url) {
      case "user_detail":
          return LoginPage();
      case "user_detail":
          return UserDetail();
      case "user_settings":
          return UserInfo(user: params,);
      case "user_tags":
          return UserTags();
      case "plant_detail":
          return PlanetDetail(plant: params);
      case "post_post":
          return PostPost();
      case "post_content":
          return PostContent(post: params);
      default:return Message();
    }
  }

  static push(BuildContext context,String url,dynamic params){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>_page(url, params)));
    // Navigator.of(context).push(ModalRoute(Rs))
  }

  static pop(BuildContext context){
    Navigator.of(context).pop();
  }
}