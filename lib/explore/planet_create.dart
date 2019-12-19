import 'package:flutter/material.dart';
import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/base/manager.dart';
import 'package:planet_social/common/PSAlert.dart';
import 'package:planet_social/models/planet_model.dart';
import 'package:planet_social/route.dart';

class PlanetCreate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlanetCreateState();
}

class _PlanetCreateState extends State<PlanetCreate> {
  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:AppBar(
          // backgroundColor: Colors.red,
          title: Text(
            "修改标签",
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              child: Image.asset(
                "assets/返回图标2.png",
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
                  )
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
          )),
        ),
      );
  }

  _createPlanet(){
    Planet planet = Planet();
    planet.title = controller.text;
    planet.ownerId = PSManager.shared.currentUser.userId;
    ApiService.shared.createPlanet(planet, (planet,error){
      if(error == null){
        PSAlert.show(context, "成功", "星球已成功创建",confirm:(){
           PSRoute.pop(context);
        });
      }else{
        PSAlert.show(context, "创建失败", error.toString());
      }
    });
  }
}
