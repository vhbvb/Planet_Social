import 'package:flutter/material.dart';
import 'package:planet_social/common/PSAlert.dart';
import 'package:planet_social/models/post_model.dart';
import 'package:planet_social/route.dart';

class Complaint extends StatefulWidget {

  final Post post;
  const Complaint({Key key, this.post}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> {

  final tags = ["垃圾营销","涉黄信息","人身攻击","有害信息","内容抄袭","违法信息"];
  String selected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('投诉', style: TextStyle(fontSize: 17.0, color: Colors.black)),
        leading: GestureDetector(
          onTap: () {
            PSRoute.pop(context);
          },
          child: Padding(
            child: Image.asset(
              "assets/back.png",
            ),
            padding: EdgeInsets.all(11),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child:Padding(padding: EdgeInsets.only(top:50,left: 15,bottom: 20),child: Text("请选择你想要的投诉类型",style: TextStyle(fontSize: 16),)),
          ),
          Wrap(
            runSpacing: 15,
            spacing: 15,
            children: tags.map((tag){
              return GestureDetector(
                onTap: (){
                  setState(() {
                    selected = tag;
                  });
                },
                child: Container(
                height: 44,
                width: (MediaQuery.of(context).size.width - 15*4)/3,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                alignment: Alignment.center,
                child: Text(tag,style: TextStyle(color:tag==selected?Color(0xFFFF8776):null),),
              ),
              );
            }).toList(),
          ),
          Padding(padding: EdgeInsets.only(top:44,left: 15,right: 15),
          child: MaterialButton(
            onPressed: _report,
            child: Container(
              alignment: Alignment.center,
              height: 50,
              decoration: BoxDecoration(
                  color: Color(0xFFFF8776),
                  borderRadius: BorderRadius.all(Radius.circular(25))
                ),
              child: Text("提 交",style: TextStyle(color:Colors.white,fontSize: 16),),
            ),
          ),)
        ],
      ),
    );
  }

  _report(){

    if(selected == null){
      PSAlert.show(context, "提示", "请选择你想要的投诉类型");
    }else{
      PSAlert.show(context, "投诉已提交", "平台已收到您的投诉，将会在24小时内进行处理");
    }
  }
}
