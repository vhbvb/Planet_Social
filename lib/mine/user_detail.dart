import 'package:flutter/material.dart';
import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/base/images.dart';
import 'package:planet_social/base/manager.dart';
import 'package:planet_social/base/utils.dart';
import 'package:planet_social/common/PSAlert.dart';
import 'package:planet_social/common/post_detail.dart';
import 'package:planet_social/models/post_model.dart';
import 'package:planet_social/models/user_model.dart';
import 'package:planet_social/route.dart';

class UserDetail extends StatefulWidget {
  User user;
  UserDetail({Key key, this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {

  List<Post> posts = [];

  List tagColors;
  bool isSelf;

  int fans=0;
  int likes=0;

  ScrollController _controller;
  double _offset = 0.0;

//用户标签
  List<Widget> _tags(){

    _build(String tag) => Padding(
      padding: EdgeInsets.only(left: 5,right: 5),
      child: Container(
      height: 30,
      padding: EdgeInsets.only(left: 10,right: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: tagColors[widget.user.tags.indexOf(tag)],
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Text(tag,style:TextStyle(color: Colors.white,fontSize: 12)),
    ),
    );

    return widget.user.tags.map(_build).toList();
  }

// header 用户信息模块
  _userInfo() { 

    List<Widget> childrens = <Widget>[
      Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 80),
        child: ClipOval(
        child: Image.network(widget.user.avatar,width: 60,height: 60,fit: BoxFit.fill,),
      ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 10,bottom: 20),
        child: Text(
          widget.user.nickName,
          style: TextStyle(color: Colors.white,fontSize: 14),
        ),
      ),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _tags(),
        ),
      Padding(
        padding: EdgeInsets.only(top: 20,bottom: 20),
        child: Container(
          color: Colors.white24,
          height: 1,
          width: MediaQuery.of(context).size.width - 50,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child:           Column(
            children: <Widget>[
              Text("粉丝",style:TextStyle(color: Colors.white,fontSize: 12)),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(fans.toString(),style:TextStyle(color: Colors.white,fontSize: 18)),
              )
            ],
          ),
          ),
          Expanded(
            child:           Column(
            children: <Widget>[
                            Text("点赞",style:TextStyle(color: Colors.white,fontSize: 12)),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(likes.toString(),style:TextStyle(color: Colors.white,fontSize: 18)),
              )
            ],
          ),
          )

        ],
      ),

      Padding(
        padding: EdgeInsets.only(top: 20,bottom: 20),
        child: GestureDetector(
          onTap: (){
            print("关注。。。。。。。。。。。");
          },
          child: Container(
            alignment: Alignment.center,
            height: 40,
            width: 176,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 139, 139),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          child: Text("关注",style: TextStyle(color: Colors.white,fontSize: 16),),
        ),
        ),
      )
    ];

    if(isSelf){
      childrens.removeLast();
    }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: childrens
  );
  }



  _header(){ 

    return SliverAppBar(
        title: Text(widget.user.nickName,
            style: TextStyle(
                color: _offset < 220.0 ? Colors.white : Colors.black)),
        centerTitle: true,
        expandedHeight: isSelf?330:350 +MediaQuery.of(context).padding.top,
        floating: false,
        pinned: true,
        snap: false,
        brightness: Brightness.light,
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              _clickSettings();
            },
            child: Padding(
              padding: EdgeInsets.only(left: 5,right: 5),
              child: Image.asset(
              _offset < 220.0 ? "assets/设置2.png" : "assets/设置.png",
              height: 22,
              width: 22,
            ),
            ),
          ),
        ],
        flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              children: <Widget>[
                Image.asset(Images.starNight,fit: BoxFit.fill,width: double.infinity),
                _userInfo()
              ],
            )
            ),
      );
  }

  _posts() => SliverList(
          delegate: SliverChildBuilderDelegate(
        (context, index) {
          return PostDetail(post: posts[index]);
        },
        childCount: posts.length
      ));

  _clickSettings(){
    PSRoute.push(context, "user_settings", widget.user);
  }


  @override
  void initState() {

    _controller = ScrollController()
      ..addListener(() {
        setState(() {
          _offset = _controller.offset;
        });
      });

    if(widget.user == null){
      widget.user = PSManager.shared.currentUser;
    }
    tagColors =  widget.user.tags.map((_)=>Util.randomColor()).toList();
    isSelf = (widget.user == PSManager.shared.currentUser);

    if(posts.length == 0){
      ApiService.shared.getPostOfUser(widget.user, (results,error){
        if(error == null){
          setState(() {
            posts.addAll(results);
          });
        }else{
          PSAlert.show(context, "帖子获取失败", error.toString());
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
        CustomScrollView(
          controller: _controller,
          slivers: <Widget>[
            _header(),
            _posts()
          ],
        ),
      ],
    ),
    );
  }
}
