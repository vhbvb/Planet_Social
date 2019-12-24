import 'package:flutter/material.dart';
import 'package:planet_social/base/utils.dart';
import 'dart:io';
import 'im_video.dart';
import 'im_voice.dart';

class MessageCellBuilder {

  MessageCellBuilder({this.onImageDoubleClick,this.onVideoDoubleClick}):super();

  Function(String) onImageDoubleClick;
  Function(String) onVideoDoubleClick;

  Widget _creatTimeTmp(bool show) {
    if (show) {
      return new Padding(
          padding: EdgeInsets.only(top: 10.0), child: new Text("08:23"));
    } else {
      return new Padding(
        padding: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

   Widget _creatIcon(bool isSend) {
    return new Padding(
      padding: EdgeInsets.only(left: 10.0, right: 5.0),
      child: new ClipOval(
          child: Util.loadImage(
        !isSend
            ? "https://i2.hdslb.com/bfs/face/d83b402cdab58ff84d415941f79b515ec14fd44f.jpg"
            : "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1021928129,596627892&fm=26&gp=0.jpg",
        height: 44.0,
        width: 44.0,
      )),
    );
  }

   Widget _creatText(String content, bool isSend) {
    //  Text(content, style: TextStyle(fontSize: 13.0));

    // Text.rich(textSpan)
    return RichText(text: TextSpan(text: content,style:TextStyle(fontSize: 13.0,color: isSend?Colors.white:Colors.black)));
  }

   Widget _creatImage(String content) {

    Widget image;
    if (content.startsWith("http")) {
      image = Util.loadImage(content);
    }else
    {
      image = Image.file(new File(content));
    }

    return new GestureDetector(
      child:image,
      onTap: (){
        this.onImageDoubleClick(content);
      },
    );
  }

   Widget _creatVideo(String content){

    FTIMVideoControl control = FTIMVideoControl(
      url:content,
      presentFullScreen: (){
      // control.presentFullScreen();
          print("on tap");
          this.onVideoDoubleClick(content);
        }
    );
    return FIIMVideoPlayerSimple(control: control);
  }

   Widget _creatVoice(String content,bool isSend){
    return FTIMVoiceSimple(control: FTIMVoiceControl(
      url: content,
      isSend: isSend
    ));
  }

   Widget _creatDetail(String content, bool isSend) {
    if (content.startsWith("image:")) {
      return _creatImage(content.substring(6));
    }

    if (content.startsWith("video:")) {
      return _creatVideo(content.substring(6));
    }

    if (content.startsWith("voice:")) {
      return _creatVoice(content.substring(6),isSend);
    }

    return _creatText(content,isSend);
  }

   BoxDecoration _creatDecoration(String content, bool isSend) {
    if (content.startsWith("image:")||content.startsWith("video:")) {
      return new BoxDecoration(
          borderRadius: BorderRadius.all(new Radius.circular(5.0)));
    }

    if (isSend) {
      return new BoxDecoration(
          image: DecorationImage(
              image: new AssetImage("assets/message_right.png"),
              fit: BoxFit.fill,
              centerSlice: Rect.fromLTWH(15.0, 15.0, 10.0, 10.0)));
    } else {
      return new BoxDecoration(
          image: DecorationImage(
              image: new AssetImage("assets/message_left.png"),
              fit: BoxFit.fill,
              centerSlice: Rect.fromLTWH(30.0, 15.0, 10.0, 10.0)));
    }
  }

   Widget _creatContent(String content, bool isSend) {
    return new Padding(
      padding: EdgeInsets.all(0.0),
      child: new Stack(
        // fit: StackFit.expand,
        alignment: AlignmentDirectional.centerStart,
        children: <Widget>[
          new ConstrainedBox(
            constraints: new BoxConstraints(
                maxWidth: 280.0, minWidth: 92.0, minHeight: 50.0),
            child: new Container(
                decoration: _creatDecoration(content, isSend),
                padding: EdgeInsets.fromLTRB(
                    isSend ? 10.0 : 33.0, 10.0, isSend ? 33.0 : 10.0, 10.0),
                child: _creatDetail(content,isSend)),
          )
        ],
      ),
    );
  }

   Widget _creatMainArch(String content, bool isSend) {
    if (isSend) {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_creatContent(content, isSend), _creatIcon(isSend)],
      );
    } else {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _creatIcon(isSend),
          _creatContent(content, isSend),
        ],
      );
    }
  }

   Widget imageCell() {
    return null;
  }

   Widget cell(String content, bool isSend, bool showTime) {
    return Container(
      // color: Colors.red,
      child: new Column(
        children: <Widget>[
          _creatTimeTmp(showTime),
          new Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
              child: _creatMainArch(content, isSend))
        ],
      ),
    );
  }
}
