import 'package:flutter/material.dart';
import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/base/data_center.dart';
import 'package:planet_social/base/manager.dart';
import 'package:planet_social/base/utils.dart';
import 'package:planet_social/common/PSAlert.dart';
import 'package:planet_social/const.dart';
import 'package:planet_social/models/post_model.dart';
import 'package:planet_social/planet/post_comment.dart';
import 'package:planet_social/route.dart';


class PostDetail extends StatefulWidget {
  PostDetail({Key key, this.post, this.parentContext}) : super(key: key);
  Post post;
  BuildContext parentContext;

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
          ClipOval(
            child: Util.loadImage(
              widget.post.owner == null
                  ? Consts.defaultAvatar
                  : widget.post.owner.avatar,
              height: 44,
              width: 44,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text(
                widget.post.owner == null ? "" : widget.post.owner.nickName,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
          ),
          Text(
            DateTime.parse(widget.post.createdAt).toString().split(".")[0],
            style: TextStyle(color: Colors.grey, fontSize: 12),
          )
        ],
      );

  _content() => GestureDetector(
      onTap: _click,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child:
            Text(widget.post.content, style: TextStyle(color: Colors.black54)),
      ));

  _footer() {

    _element(String icon,int counts,Function event) =>GestureDetector(
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

    var cmtPost = _element("assets/cmt.png", comments,_click);
    var sharePost =_element("assets/share.png", shares,(){});
    var likePost =_element(like?"assets/zan2.png":"assets/zan.png", likes,_likePost);

    var childs = <Widget>[cmtPost,sharePost,likePost];

    if (widget.parentContext != null) {
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
      double w = MediaQuery.of(context).size.width - 80;
      double imageW = w;
      if (images.length == 2) {
        imageW = w / 2;
      }

      if (images.length >= 3) {
        imageW = w / 3;
      }

      double imageH = 0.6 * imageW;

      Widget imageWidget = GestureDetector(
        child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: images.map((url) {
              return Util.loadImage(url,
                  height: imageH, width: imageW);
            }).toList()),
        onTap: () {
          //图片预览
        },
      );

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
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 15, right: 15, top: 20),
      child: Column(
        children: _mainWidgets(),
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

      ApiService.shared.checkIfLikePost(
          PSManager.shared.currentUser, widget.post, (didLike, error) {
        setState(() {
          like = didLike;
        });
      });
      
      ApiService.shared.postCommentsCount(widget.post, (count){
        setState(() {
          comments = count;
        });
      });

      ApiService.shared.postLikesCount(widget.post, (count){
        setState(() {
          likes = count;
        });
      });
  }

  _click() {
    if (widget.parentContext != null) {
      showDialog(context: widget.parentContext,builder: (_) => PostComment(post: widget.post));
    } else {
      PSRoute.push(context, "post_content", widget.post);
    }
  }

  _likePost() {
    if (widget.parentContext == null) return;

    _alertError(dynamic error) 
    {
      if (error != null)
      {
        PSAlert.show(widget.parentContext, "失败", error.toString());
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
}
