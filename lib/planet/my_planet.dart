import 'dart:async';

import 'package:flutter/material.dart';
import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/base/manager.dart';
import 'package:planet_social/base/utils.dart';
import 'package:planet_social/common/PSAlert.dart';
import 'package:planet_social/models/planet_model.dart';
import 'package:planet_social/models/post_model.dart';
import 'package:planet_social/planet/post_list.dart';
import 'package:planet_social/route.dart';

class MyPlanet extends StatefulWidget {
  Function refresh;

  @override
  State<StatefulWidget> createState() => _MyPlanetState();
}

class _MyPlanetState extends State<MyPlanet>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<Planet> imIn = [];
  final List<Post> hots = [];
  final List<Post> news = [];

  _loadNews(Function finised) {
    int i = 0;
    news.clear();
    for (var item in imIn) {
      ApiService.shared.getNewPostOfPlanet(item, (results, error) {
        i = i + 1;
        if (i == imIn.length) {
          finised();
        }
        if (error == null) {
          setState(() {
            news.addAll(results);
          });
        }
      });
    }
  }

  _loadHots(Function finised) {
    int i = 0;
    hots.clear();
    for (var item in imIn) {
      ApiService.shared.getHotPostOfPlanet(item, (results, error) {
        i = i + 1;
        if (i == imIn.length) {
          finised();
        }
        if (error == null) {
          setState(() {
            hots.addAll(results);
          });
        }
      });
    }
  }

  void _planets() {
    if (PSManager.shared.currentUser != null) {
      ApiService.shared.planetsJoined(PSManager.shared.currentUser,
          (results, error) {
        if (error == null) {
          setState(() {
            imIn.addAll(results);
            _loadHots(() {});
            _loadNews(() {});
          });
        } else {
          PSAlert.show(context, "星球获取失败", error.toString());
        }
      });
    }
  }

  @override
  void initState() {
    widget.refresh = () {
      _planets();
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "星球",
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                "我加入的星球",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
                height: 35, width: double.infinity, child: _planetsIamIn()),
            PostList(
              news: news,
              hots: hots,
              onRefresh: (pos) {
                if (pos == 0) {
                  var completer = Completer();
                  _loadNews(() {
                    completer.complete();
                  });

                  return completer.future;
                } else {
                  var completer = Completer();
                  _loadHots(() {
                    completer.complete();
                  });

                  return completer.future;
                }
              },
              onLoad: (pos) {},
            )
          ],
        ),
      ),
    );
  }

  _planetsIamIn() {
    if (imIn.length > 0) {
      return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imIn.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 18, right: 18),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  color: Util.randomColor(key: imIn[index].title)),
              child: Text(
                imIn[index].title,
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            ),
            onTap: () {
              PSRoute.push(context, "planet_detail", imIn[index]);
            },
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 30,
            width: 10,
          );
        },
      );
    } else {
      return Center(
          child: Text(
        "你还没有加入任何星球哦。",
        style: TextStyle(color: Colors.deepOrange),
      ));
    }
  }
}
