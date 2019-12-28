import 'package:flutter/material.dart';
import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/common/PSAlert.dart';
import 'package:planet_social/common/comment_detail.dart';
import 'package:planet_social/common/post_detail.dart';
import 'package:planet_social/models/comment_model.dart';
import 'package:planet_social/models/post_model.dart';
import 'package:sharesdk_plugin/sharesdk_plugin.dart';

class PostContent extends StatefulWidget {
  final Post post;
  const PostContent({Key key, this.post}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {

  List<Comment> comments = [];
  bool like = false;

  @override
  void initState() {

    ApiService.shared.getCommentsOfPost(widget.post, (results,error){
      if(error == null){
              setState(() {
        comments.addAll(results);
      });
      }else{
        PSAlert.show(context, "评论加载失败",error.toString());
      }
    });

    super.initState();
  }

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
              "assets/back.png",
            ),
            padding: EdgeInsets.all(11),
          ),
        ),
        actions: <Widget>[
          MaterialButton(
            onPressed: _share,
            child: Image.asset("assets/share2.png", height: 30, width: 30),
          )
        ],
      ),
      body: Container(
          color: Color(0xffF5F5F9),
          child: ListView.separated(
            itemCount: 1 + comments.length,
            itemBuilder: (_, index) {
              if (index == 0) {
                return PostDetail(post: widget.post,inDetail: true,);
              } else {
                return CommentDetail(comment: comments[index-1]);
              }
            },
            separatorBuilder: (_, index) {
              if (index == 0) {
                return Container(
                  padding: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  height: 47,
                  child: Text(
                    "评论",
                    style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold),
                  ),
                );
              } else {
                return Container(
                  color: Colors.white,
                );
              }
            },
          )),
    );
  }

    _share(){
     var params = SSDKMap()..setGeneral(widget.post.starTitle, widget.post.content, null, null, null, null, null, null, null, null, SSDKContentTypes.text);
     SharesdkPlugin.showMenu(null, params, (state,p,m1,m2,error){

     });
  }
}
