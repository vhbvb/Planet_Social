import 'package:flutter/material.dart';

class FTIMMedia extends StatelessWidget {
  FTIMMedia({this.control}) : super();

  final FTIMMediaControl control;

  final pageItems = [
    "assets/imtable/im_media.png",
    "assets/imtable/im_shoot.png",
  ];
  final pageItemNames = [
    "相册",
    "拍摄",
  ];
  List<Widget> _creatItems(List items, List itemNames) {
    List tmp = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      tmp.add(_creatItem(items[i], itemNames[i]));
    }
    return tmp;
  }

  GestureDetector _creatItem(String image, String name) {
    return GestureDetector(
        onTap: () {
          _itemClickHandler(name);
        },
        child: Container(
            // alignment: Alignment.topLeft,
            width: 66.0,
            // color: Colors.red,
            child: Column(
              children: <Widget>[
                Image.asset(
                  image,
                  height: 50.0,
                  width: 50.0,
                ),
                Text(
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
        break;
    }
  }

  StatelessWidget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 15.0),
        // color: Colors.green,
        height: 175.0,
        child: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 1,
            itemBuilder: (context, i) {
              return Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 30.0,
                      runSpacing: 15.0,
                      children: _creatItems(pageItems, pageItemNames)));
            }));
  }
}

class FTIMMediaControl {
  FTIMMediaControl({this.onAlbumClick, this.onShootClick, this.testFunc})
      : super();

  Function onAlbumClick;
  Function onShootClick;
  Function(int) testFunc;
  // Function
}
