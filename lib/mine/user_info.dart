import 'package:flutter/material.dart';
import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/base/utils.dart';
import 'package:planet_social/common/PSAlert.dart';
import 'package:planet_social/const.dart';
import 'package:planet_social/models/user_model.dart';
import 'package:planet_social/route.dart';
import 'package:image_picker/image_picker.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key key, this.user}) : super(key: key);
  final User user;
  @override
  State<StatefulWidget> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  bool first = false;
  @override
  void initState() {

    if(widget.user.sex == null){
      first = true;
      widget.user.sex = 0;
    }
    
    if(widget.user.avatar == null){
      widget.user.avatar = Consts.defaultAvatar;
    }

    if(widget.user.tags == null){
      widget.user.tags = [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "设置",
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
        leading: first?null:GestureDetector(
          onTap: () {
            _pop();
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
            onPressed: _save,
            child: Text("保存",style: TextStyle(color: Colors.black ,fontSize: 16),),
          )
        ],
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
              child: Util.loadImage(
                
                widget.user.avatar,
                height: 44,
                width: 44,
              ),
            ));

      case 1:
        return _rowDetail(
          index,
          "昵称",
          Text(widget.user.nickName==null?"":widget.user.nickName,
              style: TextStyle(color: Colors.black, fontSize: 14)),
        );

      case 2:
        return _rowDetail(
            index,
            "性别",
            PopupMenuButton(
              onSelected: (name){
                setState(() {
                  widget.user.sex = ["未知", "男", "女"].indexOf(name);
                });
              },
              itemBuilder: (_) {
                return ["未知", "男", "女"].map((name) {
                  return PopupMenuItem(
                    child: Text(name),
                    value: name,
                  );
                }).toList();
              },
              child: Text(["未知", "男", "女"][widget.user.sex],
                  style: TextStyle(color: Colors.black, fontSize: 14)),
            ));
        break;

      case 3:
        return _rowDetail(
            index,
            "标签",
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
                "assets/row3.png",
                width: 20,
                height: 20,
              ),
            )
          ],
        ),
      ),
    );
  }

  _pop() {
    PSRoute.pop(context);
  }

  _onClick(int index) {
    // Picker

    if (index == 0) {
      ImagePicker.pickImage(source: ImageSource.gallery).then((value) {
        print(value.path);
        
        ApiService.shared.uploadImage(value.path, (url,error){
          if(url != null){
            setState(() {
              widget.user.avatar = url;
            });
          }else{
            PSAlert.show(context, "头像上传失败", error.toString());
          }
        });
      });
    }

    if (index == 1) {
      TextEditingController controller = TextEditingController();
      showDialog(
          context: context,
          builder: (_) {
            var actions = <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("取消"),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    widget.user.nickName = controller.text;
                  });
                },
                child: Text("确定"),
              ),
            ];
            return AlertDialog(
              title: Text(
                '修改昵称',
                style: TextStyle(fontSize: 16),
              ),
              content: TextField(
                controller: controller,
                maxLength: 10,
                decoration: InputDecoration(
                    hintText: "请输入昵称", border: InputBorder.none),
              ),
              actions: actions,
            );
          });
    }

    if(index == 3){
      PSRoute.push(context, "user_tags", widget.user);
    }
  }

  List<Widget> _tags() {
    _build(String tag) => Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Container(
            height: 30,
            padding: EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Util.randomColor(key: tag),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child:
                Text(tag, style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        );

    List<String> arr = widget.user.tags;
    if (arr.length >3) {
      arr = arr.sublist(0,3);
    }
    return arr.map(_build).toList();
  }

  _save(){
    ApiService.shared.updateUserInfo(widget.user, (error){
      if(error != null){
        PSAlert.show(context, "用户更新失败", error.toString());
      }else{
        PSAlert.show(context, "成功", "信息已更新",confirm: (){
          PSRoute.pop(context);
        });
      }
    });
  }
}
