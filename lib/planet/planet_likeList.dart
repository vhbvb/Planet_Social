import 'package:flutter/material.dart';
import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/base/utils.dart';
import 'package:planet_social/common/PSAlert.dart';
import 'package:planet_social/models/planet_model.dart';
import 'package:planet_social/models/user_model.dart';
import 'package:planet_social/route.dart';

class PlanetLikeList extends StatefulWidget{
  final Planet planet;

  const PlanetLikeList({Key key, this.planet}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PlanetLikeListState();
}

class _PlanetLikeListState extends State<PlanetLikeList>{

  List<User> users=[];

  @override
  void initState() {
    ApiService.shared.planetUsers(widget.planet, (results,error){
      if(error == null){
        setState(() {
          users.addAll(results);
        });
      }else{
        PSAlert.show(context, "加载失败", error.toString());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            users.length.toString() + "个成员",
            style: TextStyle(color: Colors.black, fontSize: 17),
          ),
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
          ),),
      body: Container(
        color: Colors.grey.withAlpha(50),
        child: ListView.separated(
            itemCount: users.length,
            itemBuilder: (_,index){
              return Container(
                color: Colors.white,
                padding: EdgeInsets.all(15),
                child:GestureDetector(
                  onTap: (){
                    PSRoute.push(context, "user_detail", users[index]);
                  },
                  child: Row(
                children: <Widget>[
                  ClipOval(
                    child: Util.loadImage(users[index].avatar,height: 40,width: 40,),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(users[index].nickName,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                  )
                ],
              ),
                )
              );
            },
            separatorBuilder: (_,index){
              return Padding(padding: EdgeInsets.only(top: 1),);
            },
          ),
      )
    );
  }
  
}