import 'package:flutter/material.dart';
import 'package:planet_social/common/post_detail.dart';
import 'package:planet_social/models/post_model.dart';

class PostContent extends StatefulWidget {
  final Post post;
  const PostContent({Key key, this.post}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "帖子内容",
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
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
        actions: <Widget>[
          MaterialButton(
            onPressed: () {},
            child: Image.asset("assets/分享2.png", height: 30, width: 30),
          )
        ],
      ),
      body: Container(
          color: Color(0xffF5F5F9),
          child: ListView.separated(
            itemCount: 1 + 5,
            itemBuilder: (_, index) {
              if (index == 0) {
                return PostDetail(post: widget.post);
              } else {
                return PostDetail(post: Post());
              }
            },
            separatorBuilder: (_, index) {
              if (index == 1) {
                return Container(
                  height: 47,
                  child: Text(
                    "评论",
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                );
              } else {
                return Container(
                  height: 1,
                );
              }
            },
          )),
    );
  }
}
