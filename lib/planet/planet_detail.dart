import 'package:flutter/material.dart';
import 'package:planet_social/models/planet_model.dart';
import 'package:planet_social/planet/post_list.dart';
import 'package:planet_social/route.dart';

class PlanetDetail extends StatefulWidget {
  const PlanetDetail({Key key, this.plant}) : super(key: key);
  final Planet plant;
  @override
  State<StatefulWidget> createState() => _PlanetDetailState();
}

class _PlanetDetailState extends State<PlanetDetail> {
  _header() => GestureDetector(
    onTap: (){
      PSRoute.push(context, "user_detail", null);
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
                widget.plant.owner.avatar,
                height: 40,
                width: 40,
              )),
            ),
            Text(widget.plant.owner.nickName,
                style: TextStyle(color: Colors.white, fontSize: 14)),
            Expanded(
              child: Text(
                widget.plant.fans.toString(),
                style: TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.right,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Image.asset(
                "assets/箭头2.png",
                width: 30,
                height: 30,
              ),
            )
          ],
        ),
      ),
  );

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
                "assets/返回图标.png",
              ),
              padding: EdgeInsets.all(11),
            ),
          ),
          title: Text(widget.plant.title,
              style: TextStyle(color: Colors.black, fontSize: 17)),
          // actions: <Widget>[
          //   GestureDetector(
          //     child: Image.asset("assets/消息推送.png", height: 30, width: 30),
          //     onTap: () {
          //       print("msg........");
          //     },
          //   )
          // ],
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 50),
          child: FloatingActionButton(
            onPressed: () {
              PSRoute.push(context, "post_post", null);
            },
            child: Icon(Icons.add),
            elevation: 3.0,
            highlightElevation: 2.0,
            backgroundColor: Color(0xffFF8367),
            // 红色
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[_header(), PostList()],
          ),
        ));
  }
}
