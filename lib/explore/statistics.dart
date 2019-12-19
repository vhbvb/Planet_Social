import 'package:flutter/material.dart';

class Statistics extends StatefulWidget
{
  Statistics({this.users,this.planets}):super();

  int users;
  int planets;

  @override
  State<StatefulWidget> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {

    _comps(bool isLeft) => Container(

      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: Colors.white.withAlpha(51),
      ),

      padding: EdgeInsets.only(left: 5,right: 15,top: 0,bottom: 0),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(isLeft?"assets/users.png":"assets/stars.png",height: 30,width: 30,),
          Text(
            (isLeft?widget.users.toString():widget.planets.toString())+(isLeft?" 人":" "),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12
            ),
          )
        ],
      ),
    );

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
            _comps(true),
            Padding(padding: EdgeInsets.only(left: 20)),
            _comps(false)
        ],
      );
  }
}