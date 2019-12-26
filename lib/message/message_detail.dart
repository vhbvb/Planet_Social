import 'package:flutter/material.dart';
import 'package:planet_social/base/data_center.dart';
import 'package:planet_social/const.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
import 'package:planet_social/base/manager.dart';
import 'package:planet_social/base/utils.dart';
import 'im_video.dart';
import 'im_voice.dart';

class MessageDetail extends StatefulWidget{

  MessageDetail(this.msg,{Key key, this.onImageClick,this.onVideoClick}) : super(key: key);
  final Message msg;
  Function onImageClick;
  Function onVideoClick;
  @override
  State<StatefulWidget> createState() => _MessageDetailState();
}

class _MessageDetailState extends State<MessageDetail>{

  String avartar = Consts.defaultAvatar;

  Widget _createTimeTmp(bool show) {
    if (show) {
      return Padding(
          padding: EdgeInsets.only(top: 10.0), child: new Text("08:23"));
    } else {
      return Padding(
        padding: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

   Widget _createIcon() {
    return new Padding(
      padding: EdgeInsets.only(left: 10.0, right: 5.0),
      child: ClipOval(
          child: Util.loadImage(
        avartar,
        height: 44.0,
        width: 44.0,
      )),
    );
  }

   Widget _createText(TextMessage msg, bool isSend) {
    return RichText(text: TextSpan(text: msg.content,style:TextStyle(fontSize: 13.0,color: isSend?Colors.white:Colors.black)));
  }

   Widget _createImage(ImageMessage msg) {
    return Util.loadImage(msg.imageUri);
  }

   Widget _createVideo(SightMessage msg){

    FTIMVideoControl control = FTIMVideoControl(
      url:msg.remoteUrl,
      presentFullScreen: (){
          print("on tap");
          // this.onVideoDoubleClick(msg);
        }
    );
    return FIIMVideoPlayerSimple(control: control);
  }

   Widget _createVoice(VoiceMessage msg,bool isSend){
    return FTIMVoiceSimple(control: FTIMVoiceControl(
      url: msg.remoteUrl,
      isSend: isSend
    ));
  }

   Widget _createDetail(Message msg, bool isSend) {
    if (msg.content is ImageMessage) {
      return _createImage(msg.content as ImageMessage);
    }

    if (msg.content is SightMessage) {
      return _createVideo(msg.content as SightMessage);
    }

    if (msg.content is VoiceMessage) {
      return _createVoice(msg.content as VoiceMessage,isSend);
    }

    if (msg.content is TextMessage) {
      return _createText(msg.content as TextMessage,isSend);
    }

    return null;
  }

   BoxDecoration _createDecoration(Message msg, bool isSend) {
    if (msg.content is ImageMessage || msg.content is SightMessage) {
      return BoxDecoration(
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

   Widget _createContent(Message msg, bool isSend) {
    return  Padding(
      padding: EdgeInsets.all(0.0),
      child:  Stack(
        alignment: AlignmentDirectional.centerStart,
        children: <Widget>[
           ConstrainedBox(
            constraints:  BoxConstraints(
                maxWidth: 280.0, minWidth: 92.0, minHeight: 50.0),
            child:  Container(
                decoration: _createDecoration(msg, isSend),
                padding: EdgeInsets.fromLTRB(
                    isSend ? 10.0 : 33.0, 10.0, isSend ? 33.0 : 10.0, 10.0),
                child: _createDetail(msg,isSend)),
          )
        ],
      ),
    );
  }

   Widget _createMainArch(Message msg) {
   var isSend = msg.senderUserId == PSManager.shared.currentUser.userId;
    if (isSend) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_createContent(msg, isSend), _createIcon()],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _createIcon(),
          _createContent(msg, isSend),
        ],
      );
    }
  }

  @override
  void initState() {

    DataSource.center.getUser(widget.msg.senderUserId, (user,error){
      if(error==null){
        setState(() {
          avartar = user.avatar;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _createTimeTmp(true),
          Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
              child: _createMainArch(widget.msg))
        ],
      ),
    );
  }
}