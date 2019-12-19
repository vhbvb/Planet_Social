import 'package:flutter/material.dart';
import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/const.dart';
import 'package:planet_social/models/planet_model.dart';
import 'package:planet_social/models/user_model.dart';
import 'package:planet_social/route.dart';

class StarStyle extends StatefulWidget{

  const StarStyle({Key key, this.model, this.top, this.left, this.context}) : super(key: key);
  final model;
  final double top;
  final double left;
  final BuildContext context;

  @override
  State<StatefulWidget> createState() => _StarStyleState();
}

class _StarStyleState extends State<StarStyle> {

  Widget _create() {
    if (widget.model is Planet) {
      return GestureDetector(
        onTap: (){
          PSRoute.push(context, "planet_detail", widget.model);
        },
        child: Column(
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
                        color: widget.model.color,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  )),
              Positioned(
                // right: -10,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Image.network(
                    widget.model.owner==null?Consts.defaultAvatar:widget.model.owner.avatar,
                    height: 30,
                    width: 30,
                    fit: BoxFit.fill,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text((widget.model as Planet).title,
                style: TextStyle(
                    color: Colors.white.withAlpha(200), fontSize: 13)),
          )
        ],
      ),
      );
    } else {
      return GestureDetector(
        onTap: (){
          PSRoute.push(context, "user_detail", widget.model);
        },
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Image.network(
              (widget.model as User).avatar,
              height: 20,
              width: 20,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text((widget.model as User).nickName,
                style: TextStyle(
                    color: Colors.white.withAlpha(200), fontSize: 13)),
          )
        ],
      ),
      );
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      left: widget.left,
      child: _create(),
    );
  }

   _getModelDetail() {

     if(widget.model is Planet){
           if (widget.model.owner == null) {

            ApiService.shared.getUser(widget.model.ownerId, (user, error) {
              if (error == null) {
                setState(() {
                  widget.model.owner = user;
                });
              }
            });
    }
     }
  }
}
