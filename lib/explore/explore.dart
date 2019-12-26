import 'package:flutter/material.dart';
import 'package:planet_social/base/data_center.dart';
import 'package:planet_social/common/PSAlert.dart';
import 'package:planet_social/explore/starry_sky.dart';
import 'package:planet_social/explore/statistics.dart';
import 'package:planet_social/models/planet_model.dart';
import 'package:planet_social/route.dart';
import 'dart:math';

class Explore extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;
  
  int get planetsNumber => DataSource.center.planets.length;
  int get usersNumber => DataSource.center.users.length;

  Offset _offset = Offset(0, 0);

  double get distance {
    return sqrt(_offset.dx * _offset.dx + _offset.dy * _offset.dy);
  }

  _header() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 58, bottom: 13),
              child: Text(
                "探索",
                style: TextStyle(fontSize: 17, color: Colors.white,fontWeight: FontWeight.bold),
              )),
          Statistics(
            users: usersNumber,
            planets: planetsNumber,
          )
        ],
      );

  _distance() => Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 37),
        child: Text(
          "距离您的距离:" + distance.toStringAsFixed(2) + "光年",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ));

  @override
  void initState() {

    DataSource.center.updateExplore((error) {
      if (error != null) {
        PSAlert.show(context, "星星获取失败", error.toString());
      } else {
        setState(() {

        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          StarrySky(
              onScroll: (offset) {
                setState(() {
                  _offset = offset;
                });
              },
              stars: DataSource.center.exploreItems),
          _header(),
          _distance()
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          onPressed: _create,
          child: Icon(Icons.add),
          elevation: 3.0,
          highlightElevation: 2.0,
          backgroundColor: Color(0xffFF8367),
          // 红色
        ),
      ),
    );
  }

  _create() {
    for (var item in DataSource.center.exploreItems) {
      if (item is Planet) {
        double x = item.position.dx - _offset.dx;
        double y = item.position.dy - _offset.dy;
        double distance = sqrt(x * x + y * y);
        if (distance < 80.0) {
          PSAlert.show(context, "提示", "创建的地方离其他星球太近了哦,请重新选择地方创建您的星球。");
          return;
        }
      }
    }
    PSRoute.push(context, "planet_create", _offset);
  }
}
