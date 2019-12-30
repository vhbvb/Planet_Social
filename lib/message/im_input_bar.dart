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
  final _focus = FocusNode();
  final TextEditingController _textController = new TextEditingController();

  @override
    void initState() {

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
        super.dispose();
      }

  @override
    Widget build(BuildContext context) {

      return  Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color:Color.fromARGB(255, 229, 225, 218)
            )
          )
        ),
        constraints:  BoxConstraints(
          maxHeight:120.0
        ),
        // alignment: Alignment.topCenter,
        child:  Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

             Padding(
              padding: EdgeInsets.only(left:10.0,top:7.0),
              child: GestureDetector(
                child: Image.asset("assets/keyboard.png",height:33.0,width:33.0),
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

             Expanded(
              child: Padding(
                padding: EdgeInsets.only(left:12.0),
                child:  TextField(
                  onSubmitted: (String text){
                    _textController.text = "";
                    control.onMessageSend(text);
                  },
                  decoration: InputDecoration(
                    hintText: "请输入消息...",
                    border: InputBorder.none
                  ),
                  style:  TextStyle(
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
             Padding(
              padding: EdgeInsets.only(left:11.0,top: 7.0),
              child: GestureDetector(
                child: Image.asset("assets/emoj.png",height:33.0,width:33.0),
                onTap: (){
                  control.onEmojItemChange((emoji){
                    setState(() {
                      _textController.text = _textController.text+emoji;
                    });
                  });
                },
              )
            ),

             Padding(
              padding: EdgeInsets.only(left:19.0,right: 12.0,top: 7.0),
              child: GestureDetector(
                child: Image.asset("assets/add.png",height:33.0,width:33.0),
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

  // final FTIMChatInput input;

  bool emojSelected = false;
  bool mediaSelected = false;

  Function(bool) onFocusChange;
  Function resignFocus;
  Function(Function(String)) onEmojItemChange;
  Function onMediaItemChange;
  Function(String) onMessageSend;
}