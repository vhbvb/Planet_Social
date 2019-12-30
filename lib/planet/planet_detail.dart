import 'dart:async';
import 'package:flutter/material.dart';
import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/base/im_service.dart';
import 'package:planet_social/base/manager.dart';
import 'package:planet_social/base/utils.dart';
import 'package:planet_social/common/PSAlert.dart';
import 'package:planet_social/const.dart';
import 'package:planet_social/models/planet_model.dart';
import 'package:planet_social/models/post_model.dart';
import 'package:planet_social/planet/post_list.dart';
import 'package:planet_social/route.dart';

import '../base/data_center.dart';

class PlanetDetail extends StatefulWidget {
  const PlanetDetail({Key key, this.planet}) : super(key: key);
  final Planet planet;
  @override
  State<StatefulWidget> createState() => _PlanetDetailState();
}

class _PlanetDetailState extends State<PlanetDetail> {
  int numbers = 0;
  List<Post> news = [];
  List<Post> hots = [];
  bool like = false;

  _header() => GestureDetector(
        onTap: () {
          PSRoute.push(context, "planet_likes", widget.planet);
        },
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Color(0xffFF8367)),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10, right: 15),
                child: ClipOval(
                    child: Util.loadImage(
                  Consts.defaultAvatar,
                  height: 40,
                  width: 40,
                )),
              ),
              Text(
                  widget.planet.owner == null
                      ? "null"
                      : widget.planet.owner.nickName,
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              Expanded(
                child: Text(
                  numbers.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.right,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Image.asset(
                  "assets/row2.png",
                  width: 30,
                  height: 30,
                ),
              )
            ],
          ),
        ),
      );

  @override
  void initState() {
    _newPosts(() {});
    _hotPost(() {});
    _planetDetail();
    super.initState();
  }

  _newPosts(Function res) {
    ApiService.shared.getNewPostOfPlanet(widget.planet, (posts, error) {
      res();
      if (error == null) {
        setState(() {
          news.addAll(posts);
        });
      } else {
        PSAlert.show(context, "新帖获取失败", error.toString());
      }
    });
  }

  _hotPost(Function res) {
    ApiService.shared.getHotPostOfPlanet(widget.planet, (posts, error) {
      res();
      if (error == null) {
        setState(() {
          hots.addAll(posts);
        });
      } else {
        PSAlert.show(context, "热帖获取失败", error.toString());
      }
    });
  }

  _planetDetail() {
    if (widget.planet.owner == null) {
      DataSource.center.getUser(widget.planet.ownerId, (user, error) {
        if (error == null) {
          setState(() {
            widget.planet.owner = user;
          });
        }
      });
    }

    ApiService.shared.planetUsersCount(widget.planet, (count) {
      setState(() {
        numbers = count;
      });
    });

    ApiService.shared.islikePlanet(PSManager.shared.currentUser, widget.planet,
        (didlike, error) {
      setState(() {
        like = didlike;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              child: Image.asset(
                "assets/back.png",
              ),
              padding: EdgeInsets.all(11),
            ),
          ),
          title: Text(widget.planet.title,
              style: TextStyle(color: Colors.black, fontSize: 17)),
        ),
        floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 50), child: _floatButton()),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _header(),
              PostList(
                  news: news,
                  hots: hots,
                  onRefresh: (index) {
                    var c = Completer();
                    if (index == 0) {
                      news.clear();
                      _newPosts(() {
                        c.complete();
                      });
                    } else {
                      hots.clear();
                      _hotPost(() {
                        c.complete();
                      });
                    }

                    return c.future;
                  })
            ],
          ),
        ));
  }

  _floatButton() {
    if (like) {
      return FloatingActionButton(
        onPressed: () {
          PSRoute.push(context, "post_post", widget.planet);
        },
        child: Icon(Icons.add),
        elevation: 3.0,
        highlightElevation: 2.0,
        backgroundColor: Color(0xffFF8367),
        // 红色
      );
    } else {
      return FloatingActionButton(
        onPressed: () {
          ApiService.shared
              .joinPlanet(PSManager.shared.currentUser, widget.planet, (error) {
                if(error == null){
                  _joinChatRoom();
                }
            setState(() {
              like = (error == null);
            });
          });
        },
        child: Icon(Icons.favorite),
        elevation: 3.0,
        highlightElevation: 2.0,
        backgroundColor: Color(0xffFF8367),
        // 红色
      );
    }
  }

  _joinChatRoom(){

    IMService.shared.joinChatRoom(widget.planet.id).then((success){
      print("joinChatRoom：" + (success?"success":"fail"));
    });
  }
}
