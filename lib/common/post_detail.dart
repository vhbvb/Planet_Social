import 'package:flutter/material.dart';
import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/const.dart';
import 'package:planet_social/models/post_model.dart';
import 'package:planet_social/route.dart';

class PostDetail extends StatefulWidget {
  const PostDetail({Key key, this.post}) : super(key: key);
  final Post post;

  @override
  State<StatefulWidget> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  _header() => Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ClipOval(
            child: Image.network(
              widget.post.owner == null
                  ? Consts.defaultAvatar
                  : widget.post.owner.avatar,
              height: 33,
              width: 33,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text(
                widget.post.owner == null ? "" : widget.post.owner.nickName,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
          Text(
            widget.post.createdAt,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          )
        ],
      );

  _content() => Container(
    width: double.infinity,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child:
            Text(widget.post.content, style: TextStyle(color: Colors.black54)),
      );

  _footer() => Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text("#" + widget.post.starTitle + "#",
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
            Row(
              children: <Widget>[
                Image.asset(
                  "assets/评论图标.png",
                  height: 30,
                  width: 30,
                ),
                Text("widget.post.comments".toString(),
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 5),
                  child: GestureDetector(
                    child: Image.asset(
                      "assets/分享图标.png",
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: GestureDetector(
                    child: Image.asset(
                      "assets/点赞图标.png",
                      height: 30,
                      width: 30,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );

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

    if(images != null && images.length>0){

      double w = MediaQuery.of(context).size.width - 80;
      double imageW = w;
      if(images.length == 2){
        imageW = w/2;
      }

      if(images.length >= 3){
        imageW = w/3;
      }

      double imageH = 0.6*imageW;

      Widget imageWidget = Wrap(
        spacing: 10,
        runSpacing: 10,
        children: images.map((url){
          return Image.network(url,height: imageH,width: imageW,fit: BoxFit.fill);
        }).toList()
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
    return GestureDetector(
      onTap: () {
        PSRoute.push(context, "post_content", widget.post);
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Column(
          children: _mainWidgets(),
        ),
      ),
    );
  }

  _getPostDetail() {
    if (widget.post.owner == null) {
      ApiService.shared.getUser(widget.post.ownerId, (user, error) {
        if (error == null) {
          setState(() {
            widget.post.owner = user;
          });
        }
      });
    }
  }
}
