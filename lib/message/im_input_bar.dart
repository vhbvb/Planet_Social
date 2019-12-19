import 'package:flutter/material.dart';

class FTIMChatInput extends StatefulWidget {
  FTIMChatInput({Key key, this.uid, this.control}) : super(key: key);
  final uid;
  final FTIMChatInputControl control;

  @override
  State<StatefulWidget> createState() => new _FTIMChatInputState(
    control: control
  );
}

class _FTIMChatInputState extends State<FTIMChatInput> with TickerProviderStateMixin{
  _FTIMChatInputState({this.control}) : super();

  FTIMChatInputControl control;
  final _focus = new FocusNode();
  // AnimationController _animationController;
  final TextEditingController _textController = new TextEditingController();

  @override
    void initState() {
      // _animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
      _focus.addListener((){
        control.onFocusChange(_focus.hasFocus);
      });
      control.resignFocus = (){
        if (_focus.hasFocus)
        {
          _focus.unfocus();
        }
      };
      super.initState();
    }

  @override
    void dispose() {
        // _animationController.dispose();
        super.dispose();
      }

  @override
    Widget build(BuildContext context) {

      // TODO: implement build
      return new Container(
        // color: Colors.green.withAlpha(50),
        // padding: EdgeInsets.only(top:15.0),
        decoration: BoxDecoration(
          border:new Border(
            top: BorderSide(
              color:Color.fromARGB(255, 229, 225, 218)
            )
          )
        ),
        constraints: new BoxConstraints(
          maxHeight:120.0
        ),
        // alignment: Alignment.topCenter,
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            new Padding(
              padding: EdgeInsets.only(left:10.0,top:7.0),
              child:new GestureDetector(
                child:new Image.asset("assets/keyboard.png",height:33.0,width:33.0),
                onTap: (){
                  // _animationController.forward();
                  if (_focus.hasFocus)
                  {
                    _focus.unfocus();
                  }
                  else
                  {
                    FocusScope.of(context).requestFocus(_focus);
                  }
                },
              )
            ),

            new Expanded(
              child:new Padding(
                padding: EdgeInsets.only(left:12.0),
                child: new TextField(
                  onSubmitted: (String text){
                    _textController.text = "";
                    control.onMessageSend(text);
                  },
                  decoration:new InputDecoration(
                    hintText: "请输入消息...",
                    border: InputBorder.none
                  ),
                  style: new TextStyle(
                    fontSize:17.0,
                    color: Colors.black
                  ),
                  controller: _textController,
                  textInputAction: TextInputAction.send,
                  maxLines: null,
                  focusNode: _focus,
                  onChanged: (String text){

                    // _textController.lin;
                  },
                )
              )
            ),
            new Padding(
              padding: EdgeInsets.only(left:11.0,top: 7.0),
              child:new GestureDetector(
                child:new Image.asset("assets/emoj.png",height:33.0,width:33.0),
                onTap: (){
                  control.onEmojItemChange();
                },
              )
            ),

            new Padding(
              padding: EdgeInsets.only(left:19.0,right: 12.0,top: 7.0),
              child:new GestureDetector(
                child:new Image.asset("assets/add.png",height:33.0,width:33.0),
                onTap: (){
                  control.onMediaItemChange();
                },
              )
            ),
          ],
        ),
      );
    }
}

class FTIMChatInputControl {

  FTIMChatInputControl({this.onFocusChange,this.onEmojItemChange,this.onMediaItemChange,this.onMessageSend}) : super();
  
  bool emojSelected = false;
  bool mediaSelected = false;

  Function(bool) onFocusChange;
  Function resignFocus;
  Function onEmojItemChange;
  Function onMediaItemChange;
  Function(String) onMessageSend;
}