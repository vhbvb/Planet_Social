import 'package:flutter/material.dart';
import 'package:planet_social/models/planet_model.dart';
import 'package:planet_social/models/user_model.dart';

class StarStyle extends StatelessWidget {
  const StarStyle({Key key, this.model, this.top, this.left}) : super(key: key);
  final model;
  final double top;
  final double left;

  Widget _create() {
    if (model is Planet) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        color: model.color,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  )),
              Positioned(
                // right: -10,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Image.network(
                    (model as Planet).owner.avatar,
                    height: 30,
                    width: 30,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text((model as Planet).title,
                style: TextStyle(
                    color: Colors.white.withAlpha(200), fontSize: 13)),
          )
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Image.network(
              (model as User).avatar,
              height: 20,
              width: 20,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text((model as User).nickName,
                style: TextStyle(
                    color: Colors.white.withAlpha(200), fontSize: 13)),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: _create(),
    );
  }
}
