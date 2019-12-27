import 'package:flutter/material.dart';
import 'package:planet_social/base/utils.dart';

class ConversationDetail extends StatelessWidget {
  final String icon;
  final String title;
  final String des;
  final String updateAt;
  final int unreadCount;

  const ConversationDetail(
      {Key key,
      this.icon,
      this.title,
      this.des,
      this.updateAt,
      this.unreadCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68.0,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: ClipOval(
                child: Util.loadImage(
              icon,
              height: 55.0,
              width: 55.0,
            )),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(top: 10.0, right: 15.0),
                        child: Row(children: <Widget>[
                          Expanded(
                              child: Text(
                            title,
                            style: TextStyle(
                                color: Colors.black87, fontSize: 17.0),
                          )),
                          Text(
                            updateAt,
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ]))),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              des,
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14.0),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 15, bottom: 10),
                            child: Opacity(
                              opacity: unreadCount == 0 ? 0 : 1,
                              child: Container(
                                  padding: EdgeInsets.only(left: 6, right: 6),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.red,
                                  ),
                                  height: 20,
                                  child: Text(
                                    unreadCount.toString(),
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          )
                        ],
                      )),
                ),
                Container(height: 0.25, color: Colors.grey[500])
              ],
            ),
          )
        ],
      ),
    );
  }
}
