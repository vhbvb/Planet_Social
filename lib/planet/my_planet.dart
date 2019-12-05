import 'package:flutter/material.dart';
import 'package:planet_social/planet/post_list.dart';

class MyPlanet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyPlanetState();
}

class _MyPlanetState extends State<MyPlanet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "星球",
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Padding(
              child: Image.asset(
                "assets/消息推送.png",
                height: 30,
                width: 30,
              ),
              padding: EdgeInsets.only(right: 10),
            ),
            onTap: () {
              print("msg........");
            },
          )
        ],
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
              height: 35,
              width: double.infinity,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 18, right: 18),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        color: Colors.yellow),
                    child: Text(
                      "来自未来的火星",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 30,
                    width: 10,
                  );
                },
              ),
            ),
            PostList()
          ],
        ),
      ),
    );
  }
}
