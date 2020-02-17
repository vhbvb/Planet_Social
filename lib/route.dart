import 'package:flutter/material.dart';
import 'package:planet_social/common/complaint.dart';
import 'package:planet_social/common/login.dart';
import 'package:planet_social/explore/explore.dart';
import 'package:planet_social/explore/planet_create.dart';
import 'package:planet_social/message/chat_scaffold.dart';
import 'package:planet_social/message/conversation_list.dart';
import 'package:planet_social/mine/user_agreement.dart';
import 'package:planet_social/mine/user_detail.dart';
import 'package:planet_social/mine/user_info.dart';
import 'package:planet_social/mine/user_tags.dart';
import 'package:planet_social/planet/my_planet.dart';
import 'package:planet_social/planet/planet_detail.dart';
import 'package:planet_social/planet/planet_likeList.dart';
import 'package:planet_social/planet/post_content.dart';
import 'package:planet_social/planet/post_post.dart';

class PSRoute {
  static final explore = Explore();
  static final myPlanet = MyPlanet();
  static final message = ConversationList();
  static final me = UserDetail();

  static Widget _page(String url, dynamic params) {
    switch (url) {
      case "login":
        return LoginPage(
          result: params,
        );
      case "user_detail":
        return UserDetail(
          user: params,
        );
      case "user_settings":
        return UserInfo(
          user: params,
        );
      case "user_tags":
        return UserTags(
          user: params,
        );
      case "planet_detail":
        return PlanetDetail(planet: params);
      case "post_post":
        return PostPost(
          planet: params,
        );
      case "post_content":
        return PostContent(post: params);
      case "planet_create":
        return PlanetCreate(
          offset: params,
        );
      case "planet_likes":
        return PlanetLikeList(
          planet: params,
        );
      case "chat_scaffold":
        return ChatScaffold(
          target: params,
        );
      case "user_agreement":
        if(params == null){
          return AgreementPage();
        }else{
          return AgreementPage(isReg: params,);
        }
        break;

      case "complaint":
        return Complaint(post: params);
      default:
        return null;
    }
  }

  static push(BuildContext context, String url, dynamic params,
      {bool replace = false}) {
    if (replace) {
      Navigator.of(context).pushReplacement(
          (MaterialPageRoute(builder: (context) => _page(url, params))));
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => _page(url, params)));
    }
  }

  static pop(BuildContext context) {
    Navigator.of(context).pop();
  }
}
