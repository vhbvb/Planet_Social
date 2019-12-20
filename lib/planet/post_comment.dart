import 'package:flutter/material.dart';
import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/base/manager.dart';
import 'package:planet_social/common/PSAlert.dart';
import 'package:planet_social/models/comment_model.dart';
import 'package:planet_social/models/post_model.dart';
import 'package:planet_social/route.dart';

class PostComment extends StatefulWidget {
  final Post post;

  const PostComment({Key key, this.post}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PostCommentState();
}

class _PostCommentState extends State<PostComment> {
  var controller = TextEditingController();

  _textField() => Padding(
        padding: EdgeInsets.only(right: 10),
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 5, bottom: 5),
          width: MediaQuery.of(context).size.width - 20,
          height: 107,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              border: Border.all(color: Colors.grey, width: 0.5)),
          child: TextField(
            cursorColor: Colors.black,
            style: TextStyle(fontSize: 14),
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            maxLines: null,
            maxLength: 200,
          ),
        ),
      );

  _commitButton() => Padding(
        padding: EdgeInsets.only(top: 10, right: 10),
        child: GestureDetector(
          onTap: _commit,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(13.5)),
                color: Color(0xffFF8367)),
            height: 27,
            width: 75,
            child: Text(
              "提交",
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      height: MediaQuery.of(context).size.height - 100,
      child: Column(
        children: <Widget>[
          Expanded(
              child: GestureDetector(
            onTap: () {
              PSRoute.pop(context);
            },
            child: Opacity(
              opacity: 0.1,
              child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black),
            ),
          )),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Material(
                child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: 165,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[_textField(), _commitButton()],
              ),
            )),
          )
        ],
      ),
    ));
  }

  _commit() {
    var comment = Comment();
    comment.ownerId = PSManager.shared.currentUser.userId;
    comment.content = controller.text;
    comment.postId = widget.post.id;
    ApiService.shared.createComment(comment, (_,error){
      if(error == null){
        PSAlert.show(context, "成功","评论已发布",confirm: (){
          PSRoute.pop(context);
        });
      }else{
        PSAlert.show(context, "发布失败", error.toString());
      }
    });
  }
}
