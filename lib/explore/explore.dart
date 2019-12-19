import 'package:flutter/material.dart';
import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/common/PSAlert.dart';
import 'package:planet_social/explore/starry_sky.dart';
import 'package:planet_social/explore/statistics.dart';
import 'package:planet_social/route.dart';

class Explore extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ExploreState();
}

class _ExploreState extends State<Explore>{

  int planetsNumber = 0;
  int usersNumber = 0;
  List _elements = [];

  _header() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 58,bottom: 13),
        child: Text("探索",style: TextStyle(fontSize: 17,color: Colors.white),)
      ),
      Statistics(users: usersNumber,planets: planetsNumber,)
    ],
  );

  @override
  void initState() {

    if(_elements.length == 0){
          ApiService.shared.getExploreItems((users,planets,error){
      if(error == null){
        setState(() {
          usersNumber = users.length;
          planetsNumber = planets.length;
          _elements.addAll(users);
          _elements.addAll(planets);
        });
      }else{
        PSAlert.show(context, "星星获取失败", error.toString());
      }
    });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
      children: <Widget>[
        StarrySky(onScroll: (offset){
          // _stars.
        },
        stars: _elements),
        _header(),
      ],
    ),
    floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 50),
          child: FloatingActionButton(
            onPressed: () {
              PSRoute.push(context, "planet_create", null);
            },
            child: Icon(Icons.add),
            elevation: 3.0,
            highlightElevation: 2.0,
            backgroundColor: Color(0xffFF8367),
            // 红色
          ),
        ),
    );
  }
}