import 'package:flutter/material.dart';

class PostPost extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _PostPostState();
}

class _PostPostState extends State<PostPost>{
  @override
  Widget build(BuildContext context) {

    double l = (MediaQuery.of(context).size.width - 50)/4;

    TextEditingController controller = TextEditingController();
    return Scaffold(
           appBar: AppBar(
        title: Text(
          "发帖",
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            child: Image.asset(
              "assets/返回图标.png",
            ),
            padding: EdgeInsets.all(11),
          ),
        ),
        actions: <Widget>[
          MaterialButton(
            onPressed: (){

            },
            child: Text("发布",style: TextStyle(color: Colors.black ,fontSize: 16),),
          )
        ]
      ),

      body: Column(
        children: <Widget>[
          Container(
        padding: EdgeInsets.all(10),
        height: l+20,
        color: Color(0xFFF5F5F9),
        child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        // itemExtent: 10,
        itemBuilder: (_,index){
          return Image.asset("assets/添加图片.png",height: l,width: l,);
        },
        separatorBuilder: (_,index)=>Padding(padding: EdgeInsets.only(left: 10)
      ),
      )
          ),

      Padding(
        padding: EdgeInsets.all(10),
        child: TextField(
                controller: controller,
                maxLines: 15,
                maxLength: 1000,
                decoration: InputDecoration(
                    hintText: "写点什么...", border: InputBorder.none),
              ),
      )
        ],
      ),
    );
  }
  
}