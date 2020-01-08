import 'package:flutter/material.dart';
import 'package:planet_social/base/data_center.dart';
import 'package:planet_social/base/utils.dart';
import 'package:planet_social/const.dart';
import 'package:planet_social/models/comment_model.dart';

class CommentDetail extends StatefulWidget {
  CommentDetail({Key key, this.comment}) : super(key: key);
  Comment comment;

  @override
  State<StatefulWidget> createState() => _CommentDetailState();
}

class _CommentDetailState extends State<CommentDetail> {
  _header() => Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ClipOval(
            child: Util.loadImage(
              widget.comment.owner == null
                  ? Consts.defaultAvatar
                  : widget.comment.owner.avatar,
              height: 44,
              width: 44,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text(
                widget.comment.owner == null
                    ? ""
                    : widget.comment.owner.nickName,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
          ),
          Text(
            Util.timesTamp(DateTime.parse(widget.comment.createdAt)),
            style: TextStyle(color: Colors.grey, fontSize: 12),
          )
        ],
      );

  _content() => GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Text(widget.comment.content,
            style: TextStyle(color: Colors.black54)),
      ));

  // _breakLine() => Padding(
  //       padding: EdgeInsets.only(top: 10, bottom: 5),
  //       child: Container(
  //         height: 1,
  //         width: double.infinity,
  //         color: Colors.grey.withAlpha(44),
  //       ),
  //     );

  _mainWidgets() {
    List<Widget> widgets = [
      _header(),
      _content(),
    ];
    return widgets;
  }

  @override
  void initState() {
    _getDetail();
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

  _getDetail() {
    if (widget.comment.owner == null) {
      DataSource.center.getUser(widget.comment.ownerId, (user, error) {
        if (error == null) {
          setState(() {
            widget.comment.owner = user;
          });
        }
      });
    }
  }
}
