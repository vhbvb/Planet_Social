import 'package:flutter/material.dart';
import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/base/data_center.dart';
import 'package:planet_social/base/manager.dart';
import 'package:planet_social/base/utils.dart';
import 'package:planet_social/common/PSAlert.dart';
import 'package:planet_social/const.dart';
import 'package:planet_social/models/post_model.dart';
import 'package:planet_social/planet/post_comment.dart';
import 'package:planet_social/planet/post_list.dart';
import 'package:planet_social/route.dart';

class PostDetail extends StatefulWidget {
  PostDetail({Key key, this.post, this.postList, this.inDetail = false}) : super(key: key);
  Post post;
  bool inDetail;
  PostList postList;

  @override
  State<StatefulWidget> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  int comments = 0;
  int likes = 0;
  int shares = 0;
  bool like = false;

  _header() => Row(
        children: <Widget>[
          GestureDetector(
              onTap: _userDetail,
              behavior: HitTestBehavior.opaque,
              child: Container(
                child: Row(
                  children: <Widget>[
                    ClipOval(
                      child: Util.loadImage(
                          widget.post.owner == null
                              ? Consts.defaultAvatar
                              : widget.post.owner.avatar,
                          height: 44,
                          width: 44,
                          onTap: _userDetail),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                          widget.post.owner == null
                              ? ""
                              : widget.post.owner.nickName,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              )),
          Text(
            Util.timesTamp(DateTime.parse(widget.post.createdAt)),
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          widget.post.ownerId == PSManager.shared.currentUser.userId?null:Expanded(child: Align(alignment: Alignment.centerRight,child: 
          IconButton(padding: EdgeInsets.only(left:25),icon: Icon(Icons.more_vert),color: Colors.grey, onPressed: (){
            _showDialog();
          }),))
        ],
      );

  _content() => Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 10, bottom: 10,left: 5,right: 5),
        child:
            Text(widget.post.content, style: TextStyle(color: Colors.black54)),
      );

  _footer() {
    _element(String icon, int counts, Function event) => GestureDetector(
          onTap: event,
          child: Row(
            children: <Widget>[
              Image.asset(
                icon,
                height: 30,
                width: 30,
              ),
              Text(counts.toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 12))
            ],
          ),
        );

    var cmtPost = _element("assets/cmt.png", comments, _click);
    var sharePost = _element("assets/share.png", shares, () {});
    var likePost =
        _element(like ? "assets/zan2.png" : "assets/zan.png", likes, _likePost);

    var childs = <Widget>[cmtPost, sharePost, likePost];

    if (widget.inDetail) {
      childs.removeAt(1);
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text("#" + widget.post.starTitle + "#",
                style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          Row(children: childs)
        ],
      ),
    );
  }

  _breakLine() => Padding(
        padding: EdgeInsets.only(top: 10, bottom: 5),
        child: Container(
          height: 1,
          width: double.infinity,
          color: Colors.grey.withAlpha(44),
        ),
      );

  _mainWidgets() {
    List<Widget> widgets = [
      _header(),
      _content(),
      _breakLine(),
      _footer(),
    ];

    List images = widget.post.images;
    if (images != null && images.length > 0) {
      double w = MediaQuery.of(context).size.width - 50;
      double imageW = w;
      double imageH;
      if (images.length >= 2) {
        imageW = w / 2 - 10;
        imageH = 1.5 * imageW;
      }

      Widget imageWidget = Wrap(
          spacing: 10,
          runSpacing: 10,
          children: images.map((url) {
            return Util.loadImage(url,
                height: imageH,
                width: imageW,
                context: context,
                enablePreview: true,
                sources: widget.post.images);
          }).toList());

      widgets.insert(2, imageWidget);
    }

    return widgets;
  }

  @override
  void initState() {
    _getPostDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _click,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Column(
          children: _mainWidgets(),
        ),
      ),
    );
  }

  _getPostDetail() {
    if (widget.post.owner == null) {
      DataSource.center.getUser(widget.post.ownerId, (user, error) {
        if (error == null) {
          setState(() {
            widget.post.owner = user;
          });
        }
      });
    }

    ApiService.shared.checkIfLikePost(PSManager.shared.currentUser, widget.post,
        (didLike, error) {
      setState(() {
        like = didLike;
      });
    });

    ApiService.shared.postCommentsCount(widget.post, (count) {
      setState(() {
        comments = count;
      });
    });

    ApiService.shared.postLikesCount(widget.post, (count) {
      setState(() {
        likes = count;
      });
    });
  }

  _click() {
    if (widget.inDetail) {
      showDialog(
          context: context, builder: (_) => PostComment(post: widget.post));
    } else {
      ApiService.shared.clickPost(widget.post);
      PSRoute.push(context, "post_content", widget.post);
    }
  }

  _likePost() {
    if (!widget.inDetail) return;

    _alertError(dynamic error) {
      if (error != null) {
        PSAlert.show(context, "失败", error.toString());
      }
    }

    if (like) {
      var current = PSManager.shared.currentUser;
      ApiService.shared.dislikePost(current, widget.post, (error) {
        setState(() {
          like = (error != null);
        });
        _alertError(error);
      });
    } else {
      var current = PSManager.shared.currentUser;
      ApiService.shared.likePost(current, widget.post, (error) {
        setState(() {
          like = (error == null);
        });
        _alertError(error);
      });
    }
  }

  _userDetail() {
    if (widget.post.owner != null) {
      PSRoute.push(context, "user_detail", widget.post.owner);
    }
  }

  _showDialog(){
    showModalBottomSheet(context: context, 
    builder: (BuildContext context) {
      return Container(
        height: 100 + MediaQuery.of(context).padding.bottom,
        child: ListView.separated(
        itemBuilder: (context, index) {
          var names = ["屏蔽此用户","投诉","取消"];

          Function block = (){
            //屏蔽
            ApiService.shared.block(PSManager.shared.currentUser, widget.post.owner, (error){
              PSManager.shared.blocks.add(widget.post.owner);
              PSRoute.myPlanet.refresh();
              widget.postList?.refresh();
            });

            PSRoute.pop(context);
          };
          Function report = (){
            PSRoute.push(context, "complaint", widget.post,replace: true);
          };
          Function cancel = (){
            PSRoute.pop(context);
          };

          var funs = [block,report,cancel];

          return GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Padding(padding: EdgeInsets.all(5),child: Center(child:Text(names[index])),),
              onTap: funs[index]
            );

        }, 
        separatorBuilder: (_,index){
          return Container(color: Colors.grey[200],height: index==1?3:0.5,);
        }, 
        itemCount: 3),
      );
    });
  }
}
