import 'package:flutter/material.dart';

class PSAlert {
  static show(BuildContext context,String title,String des,{Function confirm}){
        showDialog(
        context: context,
        builder: (_) =>  AlertDialog(
                title:  Text(title),
                content:  Text(des),
                actions: <Widget>[
                   FlatButton(
                    child:  Text("确定"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if(confirm != null){
                        confirm();
                      }
                    },
                  )
                ]));
  }

  static showConfirm(BuildContext context,String title,Function confirm){
        showDialog(
        context: context,
        builder: (_) =>  AlertDialog(
                title:  Text(title),
                actions: <Widget>[
                   FlatButton(
                    child:  Text("取消"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                                     FlatButton(
                    child:  Text("确定"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      confirm();
                    },
                  ),
                ]));
  }
}