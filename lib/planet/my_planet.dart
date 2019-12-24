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
  @override
  State<StatefulWidget> createState() => _MyPlanetState();
}

class _MyPlanetState extends State<MyPlanet> with AutomaticKeepAliveClientMixin{
  
    @override
  bool get wantKeepAlive => true;

  final List<Planet> imIn = [];
  final List<Post> hots = [];
  final List<Post> news = [];

  @override
  void initState() {

        _loadPosts(){

      for (var item in imIn) 
      {
        ApiService.shared.getHotPostOfPlanet(item, (results,error){
          if(error == null){
            setState(() {
              hots.addAll(results);
            });
          }
        });  

        ApiService.shared.getNewPostOfPlanet(item, (results,error){
                    if(error == null){
            setState(() {
              news.addAll(results);
            });
          }
        });  
      }
    }

    PSManager.shared.isLogin.then((isLogined){

      if(isLogined){

            ApiService.shared.planetsJoined(PSManager.shared.currentUser, (results,error){
      if(error == null){
        setState(() {
          imIn.addAll(results);
        });
        _loadPosts();
      }else{
        PSAlert.show(context, "星球获取失败", error.toString());
      }
    });

      }
    });
    
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
              height: 35,
              width: double.infinity,
              child: _planetsIamIn()
            ),
            PostList(news:news,hots: hots,)
          ],
        ),
      ),
    );
  }

  _planetsIamIn(){
    if(imIn.length > 0){
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
                        color: Util.randomColor(key:imIn[index].title)),
                    child: Text(
                      imIn[index].title,
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                  onTap: (){
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
    }else{
      return Center(child: Text("你还没有加入任何星球哦。",style: TextStyle(color: Colors.deepOrange),));
    }
  }
}
