import 'package:flutter/material.dart';
import 'package:planet_social/base/utils.dart';
import 'package:planet_social/models/user_model.dart';
import 'package:planet_social/route.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key key, this.user}) : super(key: key);
  final User user;
  @override
  State<StatefulWidget> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "设置",
        style: TextStyle(color: Colors.black, fontSize: 17),

      ),

      leading: GestureDetector(
        onTap: (){
          _pop();
        },
        child: Padding(child: Image.asset("assets/返回图标.png",),padding: EdgeInsets.all(11),),
      ),
      
      ),
      
      body: ListView.separated(
        itemBuilder: (context, index) {
          return _create(index);
        },
        itemCount: 4,
        separatorBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Container(height: 1, color: Colors.grey[100]),
          );
        },
      ),
    );
  }

  _create(int index) {
    switch (index) {
      case 0:
        return _rowDetail(
            index,
            "头像",
            ClipOval(
              child: Image.network(
                widget.user.avatar,
                height: 64,
                width: 64,
              ),
            ));

      case 1:
        return _rowDetail(
          index,
          "昵称",
          Text(widget.user.nickName,
              style: TextStyle(color: Colors.black, fontSize: 14)),
        );

      case 2:
        return _rowDetail(
          index,
          "性别",
          Text(["未知", "男", "女"][widget.user.sex],
              style: TextStyle(color: Colors.black, fontSize: 14)),
        );
        break;

      case 3:
        return _rowDetail(
            index,
            "性别",
            Row(
              children: _tags(),
              mainAxisAlignment: MainAxisAlignment.end,
            ));
        break;
      default:
    }
  }

  _rowDetail(int index, String title, Widget body) {
    return GestureDetector(
      onTap: () {
        _onClick(index);
      },
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(title, style: TextStyle(color: Colors.black, fontSize: 14)),
            Expanded(
              child: Container(
                child: body,
                alignment: Alignment.centerRight,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Image.asset(
                "assets/箭头3.png",
                width: 20,
                height: 20,
              ),
            )
          ],
        ),
      ),
    );
  }

  _pop(){
    PSRoute.pop(context);
  }

  _onClick(int index) {
    
  }

  List<Widget> _tags() {
    _build(String tag) => Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Container(
            height: 30,
            padding: EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Util.randomColor(),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child:
                Text(tag, style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        );

    return widget.user.tags.map(_build).toList();
  }
}
