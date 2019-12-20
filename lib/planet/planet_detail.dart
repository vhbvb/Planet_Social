import 'dart:math';

import 'package:flutter/material.dart';
import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/base/manager.dart';
import 'package:planet_social/common/PSAlert.dart';
import 'package:planet_social/const.dart';
import 'package:planet_social/models/planet_model.dart';
import 'package:planet_social/models/post_model.dart';
import 'package:planet_social/planet/post_list.dart';
import 'package:planet_social/route.dart';

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
    onTap: (){
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
                  child: Image.network(
                Consts.defaultAvatar,
                height: 40,
                width: 40,
              )),
            ),
            Text(widget.planet.owner==null?"null":widget.planet.owner.nickName,
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

    ApiService.shared.getHotPostOfPlanet(widget.planet, (posts,error){
      if(error == null){
        setState(() {
          hots.addAll(posts);
        });
      }else{
        PSAlert.show(context, "热帖获取失败", error.toString());
      }
    });

    ApiService.shared.getNewPostOfPlanet(widget.planet, (posts,error){
      if(error == null){
        setState(() {
          news.addAll(posts);
        });
      }else{
        PSAlert.show(context, "新帖获取失败", error.toString());
      }
    });

    ApiService.shared.planetUsersCount(widget.planet, (count){
      setState(() {
        numbers = count;
      });
    });

    ApiService.shared.islikePlanet(PSManager.shared.currentUser,widget.planet, (didlike,error){
      setState(() {
        like = didlike;
      });
    });

    super.initState();
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
          padding: EdgeInsets.only(bottom: 50),
          child: _floatButton()
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[_header(), PostList(news: news,hots: hots,)],
          ),
        ));
  }

  _floatButton(){

    if(like){
      return      FloatingActionButton(
            onPressed: (){PSRoute.push(context, "post_post", widget.planet);},
            child: Icon(Icons.add),
            elevation: 3.0,
            highlightElevation: 2.0,
            backgroundColor: Color(0xffFF8367),
            // 红色
          );
    }else{
            return  FloatingActionButton(
            onPressed: (){
              ApiService.shared.joinPlanet(PSManager.shared.currentUser,widget.planet, (error){
                setState(() {
                  like = (error==null);
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
}
