import 'package:flutter/material.dart';
import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/base/im_service.dart';
import 'package:planet_social/base/manager.dart';
import 'package:planet_social/common/PSAlert.dart';
import 'package:planet_social/models/planet_model.dart';
import 'package:planet_social/route.dart';
import 'dart:math';

class PlanetCreate extends StatefulWidget {
  final Offset offset;

  const PlanetCreate({Key key, this.offset}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PlanetCreateState();
}

class _PlanetCreateState extends State<PlanetCreate> {
  
    double get distance {
    var x = widget.offset.dx;
    var y = widget.offset.dy;
    return sqrt(x*x+ y*y);
  }
  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:AppBar(
          // backgroundColor: Colors.red,
          title: Text(
            "创建星球",
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              child: Image.asset(
                "assets/back2.png",
              ),
              padding: EdgeInsets.all(11),
            ),
          ),
          flexibleSpace: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: ExactAssetImage("assets/star/star.jpeg"),
                  fit: BoxFit.fill)),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildCreate(),
              _distance()
            ],
          )
          ),
        ),
      );
  }

  _buildCreate() => SingleChildScrollView(
    child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(23)),
                        color: Color(0xff404040)),
                    height: 46,
                    width: MediaQuery.of(context).size.width - 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: SizedBox(
                      height: 46,
                      width: MediaQuery.of(context).size.width - 90,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: controller,
                        style: TextStyle(color: Colors.white),
                        maxLength: 11,
                        cursorColor: Colors.white,
                        buildCounter: (BuildContext context,
                                {int currentLength,
                                int maxLength,
                                bool isFocused}) =>
                            null,
                        decoration: InputDecoration(
                          hintText: "星球名称",
                          hintStyle: TextStyle(
                            color: Colors.white.withAlpha(150),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 46)),
              GestureDetector(
                onTap: _createPlanet,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(23)),
                      color: Color(0xffFF8367)),
                  height: 46,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    "创建",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
  );

  _distance() => Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: EdgeInsets.only(bottom: 37),
      child: Text("距离您的距离:"+distance.toStringAsFixed(2)+"光年",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
    )
  );

  _createPlanet(){
    Planet planet = Planet();
    planet.title = controller.text;
    planet.ownerId = PSManager.shared.currentUser.userId;
    planet.position = Offset(-widget.offset.dx, -widget.offset.dy);
    ApiService.shared.createPlanet(planet, (res,error){
      if(error == null){
        PSRoute.explore.refresh();
        _createChatRoom(res.id,planet.title);
        PSAlert.show(context, "成功", "星球已成功创建",confirm:(){
           PSRoute.pop(context);
        });
      }else{
        PSAlert.show(context, "创建失败", error.toString());
      }
    });
  }

  _createChatRoom(String id, String title){
    IMService.shared.createChatRoom(id,title,(error){
      if(error == null){
        print("create chat group success!");
      }else{
        print("error in create chat group:$error");
      }
    });
  }
}
