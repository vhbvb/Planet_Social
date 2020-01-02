import 'dart:async';

import 'package:flutter/material.dart';
import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/base/images.dart';
import 'package:planet_social/base/manager.dart';
import 'package:planet_social/base/utils.dart';
import 'package:planet_social/common/PSAlert.dart';
import 'package:planet_social/common/post_detail.dart';
import 'package:planet_social/const.dart';
import 'package:planet_social/models/post_model.dart';
import 'package:planet_social/models/user_model.dart';
import 'package:planet_social/route.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class UserDetail extends StatefulWidget {
  User user;
  UserDetail({Key key, this.user}) : super(key: key);
  Function refresh;

  @override
  State<StatefulWidget> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Post> posts = [];

  List tagColors;
  bool _isSelf = false;

  int fans = 0;
  int likes = 0;
  int likeState = 0; //0未知 1喜欢，-1不喜欢

  String get _nickName {
    if (widget.user != null && widget.user.nickName != null) {
      return widget.user.nickName;
    } else {
      return "";
    }
  }

  String get _avatar {
    if (widget.user != null && widget.user.avatar != null) {
      return widget.user.avatar;
    } else {
      return Consts.defaultAvatar;
    }
  }

  ScrollController _controller;
  double _offset = 0.0;

//用户标签
  List<Widget> _tags() {
    if (widget.user == null || widget.user.tags == null) {
      return [];
    }

    _build(String tag) => Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Container(
            height: 30,
            padding: EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Util.randomColor(key: tag),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child:
                Text(tag, style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        );

    var arr = widget.user.tags;

    arr = arr.length>3?arr.sublist(0,3):arr;

    return arr.map(_build).toList();
  }

// header 用户信息模块
  _userInfo() {
    List<Widget> childrens = <Widget>[
      Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 80),
        child: ClipOval(
          child: Util.loadImage(
            _avatar,
            width: 60,
            height: 60,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 10, bottom: 20),
        child: Text(
          _nickName,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _tags(),
      ),
      Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
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
            child: Column(
              children: <Widget>[
                Text("粉丝", style: TextStyle(color: Colors.white, fontSize: 12)),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(fans.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text("点赞", style: TextStyle(color: Colors.white, fontSize: 12)),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(likes.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                )
              ],
            ),
          )
        ],
      ),
    ];

    Widget attention = Padding(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: GestureDetector(
        onTap: _like,
        child: Container(
          alignment: Alignment.center,
          height: 40,
          width: 176,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 139, 139),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Text(
            likeState < 0 ? "关注" : "已关注",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );

    if (!_isSelf && likeState != 0) {
      childrens.add(attention);
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center, children: childrens);
  }

  _header() {
    return SliverAppBar(
      title: Text(_nickName,
          style: TextStyle(
              color: _offset < 220.0 ? Colors.white : Colors.black,
              fontSize: 17)),
      centerTitle: true,
      expandedHeight: _isSelf ? 330 : 375 + MediaQuery.of(context).padding.top,
      floating: false,
      pinned: true,
      snap: false,
      brightness: Brightness.light,
      actions: _action(),
      flexibleSpace: FlexibleSpaceBar(
          background: Stack(
        children: <Widget>[
          Image.asset(Images.starNight,
              fit: BoxFit.fill, width: double.infinity),
          _userInfo()
        ],
      )),
    );
  }

  List<Widget> _action() {
    var setIcon = Padding(
      padding: EdgeInsets.only(right: 10),
      child: GestureDetector(
      onTap: _clickSetting,
      child: Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Image.asset(
          _offset < 220.0 ? "assets/set2.png" : "assets/set.png",
          height: 22,
          width: 22,
        ),
      ),
    ),
    );

    var msgIcon = Padding(
      padding: EdgeInsets.only(right: 10),
      child:GestureDetector(
      onTap: _clickMessage,
      child: Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Image.asset(
          _offset < 220.0 ? "assets/msg_push2.png" : "assets/msg_push.png",
          height: 33,
          width: 33,
        ),
      ),
    ));

    return [_isSelf ? setIcon : msgIcon];
  }

  _clickSetting() {
    PSRoute.push(context, "user_settings", widget.user);
  }

  _clickMessage() {
    PSRoute.push(context, "chat_scaffold", widget.user);
  }

  _posts() => SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return PostDetail(
          post: posts[index],
        );
      }, childCount: posts.length));

  @override
  void initState() {
    widget.refresh = () {
      setState(() {
        _fresh((){});
      });
    };

    _fresh(() {});

    // 状态栏渐变
    _controller = ScrollController()
      ..addListener(() {
        setState(() {
          _offset = _controller.offset;
        });
      });

    super.initState();
  }

  _fresh(Function res) {
    // 变量初始化
    if (widget.user == null) {
      widget.user = PSManager.shared.currentUser;
      _isSelf = true;
    }

    if (widget.user != null) {
//获取帖子
        ApiService.shared.getPostOfUser(widget.user, (results, error) {
          res();
          if (error == null) {
            setState(() {
              posts.clear();
              posts.addAll(results.reversed);
            });
          } else {
            PSAlert.show(context, "帖子获取失败", error.toString());
          }
        });

      //检查是否关注
      if (!_isSelf) {
        ApiService.shared.checkIfLikeUser(
            PSManager.shared.currentUser, widget.user, (didlike, error) {
          setState(() {
            likeState = didlike ? 1 : -1;
          });
        });
      }

      ApiService.shared.userLikesCount(widget.user, (count) {
        setState(() {
          likes = count;
        });
      });

      ApiService.shared.userFansCount(widget.user, (count) {
        setState(() {
          fans = count;
        });
      });
    }else{
      res();
    }
  }

  @override
  Widget build(BuildContext context) {
    Util.setStatusBarStyle(_offset<220.0);
    super.build(context);
    return Scaffold(
      body: EasyRefresh(
          onRefresh: () {
                    var c = Completer();
        _fresh(() {
          c.complete();
        });
        return c.future;
          },
          child: CustomScrollView(
            controller: _controller,
            slivers: <Widget>[_header(), _posts()],
          )),
    );
  }

  //  点击关注
  _like() {
    _alertError(dynamic error) {
      if (error != null) {
        PSAlert.show(context, "失败", error.toString());
      }
    }

    if (likeState == 1) {
      var current = PSManager.shared.currentUser;
      ApiService.shared.dislikeUser(current, widget.user, (error) {
        setState(() {
          likeState = (error == null) ? -1 : 1;
        });
        _alertError(error);
      });
    } else {
      var current = PSManager.shared.currentUser;
      ApiService.shared.likeUser(current, widget.user, (error) {
        setState(() {
          likeState = (error == null) ? 1 : -1;
        });
        _alertError(error);
      });
    }
  }
}
