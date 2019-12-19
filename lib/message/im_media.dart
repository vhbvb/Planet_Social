import 'package:flutter/material.dart';

class FTIMMedia extends StatelessWidget {
  FTIMMedia({this.control}) : super();

  final FTIMMediaControl control;

  final firstPageItems = [
    "assets/imtable/im_media.png",
    "assets/imtable/im_shoot.png",
    "assets/imtable/im_position.png",
    "assets/imtable/im_jankenpo.png",
    "assets/imtable/im_redpacket.png",
    "assets/imtable/im_redpacket.png",
    "assets/imtable/im_redpacket.png",
    "assets/imtable/im_redpacket.png"
  ];
  final firstPageItemNames = [
    "相册",
    "拍摄",
    "位置",
    "石头剪刀布",
    "视频通话",
    "文件传输",
    "提示消息",
    "已读回执"
  ];
  final secondPageItems = ["assets/imtable/im_redpacket.png"];
  final secondPageItemNames = ["红包"];
  List<Widget> _creatItems(List items, List itemNames) {
    List tmp = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      tmp.add(_creatItem(items[i], itemNames[i]));
    }
    return tmp;
  }

  GestureDetector _creatItem(String image, String name) {
    return new GestureDetector(
        onTap: () {
          _itemClickHandler(name);
        },
        child: new Container(
            // alignment: Alignment.topLeft,
            width: 66.0,
            // color: Colors.red,
            child: new Column(
              children: <Widget>[
                new Image.asset(
                  image,
                  height: 50.0,
                  width: 50.0,
                ),
                new Text(
                  name,
                  style: TextStyle(fontSize: 12.0),
                )
              ],
            )));
  }

  void _itemClickHandler(String itemName) {
    switch (itemName) {
      case "相册":
        control.onAlbumClick();
        break;
      case "拍摄":
        control.onShootClick();
        break;
      default:
        control.testFunc(firstPageItemNames.indexOf(itemName));
        break;
    }
  }

  StatelessWidget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.only(top: 15.0),
        // color: Colors.green,
        height: 175.0,
        child: new PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            itemBuilder: (context, i) {
              return new Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: new Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 30.0,
                      runSpacing: 15.0,
                      children: _creatItems(
                          i == 0 ? firstPageItems : secondPageItems,
                          i == 0 ? firstPageItemNames : secondPageItemNames)));
            }));
  }
}

class FTIMMediaControl {

  FTIMMediaControl({this.onAlbumClick,this.onShootClick,this.testFunc}):super();

  Function onAlbumClick;
  Function onShootClick;
  Function(int) testFunc;
  // Function
}
