import 'package:flutter/material.dart';
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
            child: Image.network(widget.post.owner.avatar,height: 40,width: 40,),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5, right: 10),
            child: Text(widget.post.owner.nickName,
                style: TextStyle(color: Colors.black, fontSize: 12)),
          ),
          Text(
            widget.post.createAt,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          )
        ],
      );

  _content() => Container(
        padding: EdgeInsets.only(top: 5, bottom: 10),
        child:
            Text(widget.post.content, style: TextStyle(color: Colors.black54)),
      );

  _footer() => Padding(
    padding: EdgeInsets.only(top: 5),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text("#" + widget.post.star + "#",
                style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          Row(
            children: <Widget>[
              Image.asset(
                  "assets/评论图标.png",
                  height: 30,
                  width: 30,
                ),
              Text(widget.post.comments.toString(),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        PSRoute.push(context, "post_content", widget.post);
      },
      child: Container(
        color: Colors.white,
      padding: EdgeInsets.only(left: 15,right: 15,top: 20),
      child: Column(
        children: <Widget>[
          _header(),
          _content(),
          Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.withAlpha(44),
            ),
          _footer(),
        ],
      ),
    ),
    );
  }
}
