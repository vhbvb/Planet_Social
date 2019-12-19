import 'dart:math';
import 'package:flutter/material.dart';
import 'package:planet_social/base/utils.dart';
import 'package:planet_social/common/PSAlert.dart';
import 'package:planet_social/models/user_model.dart';

class UserTags extends StatefulWidget {

  final User user ;
  const UserTags({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UserTagsState();
}

class UserTagsState extends State<UserTags> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "修改标签",
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
        ),
        body: Container(
          color: Color(0xFFF5F5F9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 10, right: 5,top: 5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                            hintText: "请输入你的标签", border: InputBorder.none),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          widget.user.tags.add(controller.text);
                          controller.text = "";
                        });
                      },
                      child: Text(
                        "添加",
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: widget.user.tags.map((tag) {
                      return GestureDetector(
                        onTap: (){
                          PSAlert.showConfirm(context, "确定删除此标签？", (){
                            setState(() {
                              widget.user.tags.remove(tag);
                            });
                          });
                        },
                        child: Container(
                        padding: EdgeInsets.only(left: 12, right: 12,top: 5,bottom: 5),
                        decoration: BoxDecoration(
                          color: Util.randomColor(),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Text(tag,
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                      );
                    }).toList(),
                  ))
            ],
          ),
        ));
  }
}
