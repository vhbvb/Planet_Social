import 'dart:async';
import 'package:flutter/material.dart';
import 'package:planet_social/base/im_service.dart';
import 'package:planet_social/message/message_detail.dart';
import 'package:planet_social/models/planet_model.dart';
import 'package:planet_social/models/user_model.dart';
import 'package:planet_social/route.dart';
import './im_input_bar.dart';
import './im_emoj.dart';
import './im_media.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';

class ChatScaffold extends StatefulWidget {
  ChatScaffold({Key key, this.target}) : super(key: key);
  final target;

  @override
  State<StatefulWidget> createState() => _ChatScaffoldState();
}

class _ChatScaffoldState extends State<ChatScaffold>
    with TickerProviderStateMixin {
  final _messages = [];
  final _scrollController = ScrollController();
  FTIMChatInputControl _inputControl;
  FTIMMediaControl _mediaControl;
  IMServiceObserver _observer;

  Function(String) _emojSelected;

  String get targetId {
    if (widget.target is User){
      return widget.target.userId;
    }

    if (widget.target is Planet){
      return widget.target.id;
    }
    return null;
  }

  int get type {
        if (widget.target is Planet){
      return RCConversationType.ChatRoom;
    }

    return RCConversationType.Private;
  }

  String get title{
    if (widget.target is User){
      return widget.target.nickName;
    }

    if (widget.target is Planet){
      return widget.target.title;
    }
    return null;
  }

  Widget _creatExt() {
    if (_inputControl.emojSelected) {
      return FTIMEmoj(onSelected: _emojSelected);
    } else if (_inputControl.mediaSelected) {
      return FTIMMedia(control: _mediaControl);
    } else {
      return Container();
    }
  }

  List<Widget> _actions(){
    if(widget.target is Planet){
         return <Widget>[GestureDetector(
      onTap: (){
        PSRoute.push(context, "planet_likes", widget.target);
      },
      child: Padding(
        padding: EdgeInsets.only(right: 10),
        child: Image.asset(
          "assets/users_list.png",
          height: 25,
          width: 25,
        ),
      )
    )];
    }else{
      return <Widget>[];
    }
  }

  @override
  void initState() {
    _setupVariables();
    _refresh();
    IMService.shared.sendReadReceipt(targetId);
    super.initState();
  }

  _setupVariables() {
    _inputControl = FTIMChatInputControl(onFocusChange: (bool focus) {
      if (focus) {
        _inputControl.mediaSelected = false;
        _inputControl.emojSelected = false;
      }
      setState(() {
        if (focus) {
          _scrollController.animateTo(0.0,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 333));
        }
      });
    }, onEmojItemChange: (onSelected) {
      _emojSelected = onSelected;
      _inputControl.resignFocus();
      // Future.delayed(new Duration(milliseconds:333),(){
      _inputControl.mediaSelected = false;
      _inputControl.emojSelected = !_inputControl.emojSelected;
      setState(() {});
      // });
    }, onMediaItemChange: () {
      _inputControl.resignFocus();
      // Future.delayed(new Duration(milliseconds:333),(){
      _inputControl.emojSelected = false;
      _inputControl.mediaSelected = !_inputControl.mediaSelected;
      setState(() {});
      // });
    }, onMessageSend: (String text) {
      _sendText(text);
    });

    _mediaControl = FTIMMediaControl(onAlbumClick: () {
      _sendImage(true);
    }, onShootClick: () {
      _sendImage(false);
    });

    _observer = IMServiceObserver()
      ..onrev = (msg, needFresh) {
        if (msg.targetId == targetId) {
          if (needFresh) {
            setState(() {
              _messages.insert(0, msg);
            });
          }
        }
      };
  }

  @override
  void dispose() {
    _observer.dispose();
    IMService.shared.sendReadReceipt(targetId,type: type);
    // if(widget.target is Planet){
    //   IMService.shared.quitChatRoom(widget.target.id);
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List images = [];
    for (var item in _messages) {
      var content = (item as Message).content;
      if (content is ImageMessage) {
        images.add(content.imageUri);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(title,
              style: TextStyle(fontSize: 17.0, color: Colors.black)),
          leading: GestureDetector(
              child: Padding(
                child: Image.asset("assets/back.png"),
                padding: EdgeInsets.all(10),
              ),
              onTap: () {
                Navigator.pop(context);
              }),
          actions: _actions(),
        ),
        body: GestureDetector(
          onTap: _resignAllFocus,
          child: Stack(
            children: <Widget>[
              SafeArea(
                  bottom: true,
                  child: Column(children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                          reverse: true,
                          controller: _scrollController,
                          itemCount: _messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            return MessageDetail(
                              _messages[index],
                              images: images,
                            );
                          }),
                    ),
                    Container(
                        constraints:
                            BoxConstraints(minHeight: 50.0, maxHeight: 200.0),
                        child: FTIMChatInput(
                          control: _inputControl,
                        )),
                    _creatExt()
                  ])),
            ],
          ),
        ));
  }

  Future _refresh({islocal = false}) async {
    _messages.clear();
    if(widget.target is Planet){
      var res = await IMService.shared.joinChatRoom(widget.target.id);
      print("joinChatRoom：" + (res?"success":"fail"));
    }
    var msgs = await IMService.shared.localMessagesList(targetId,type: type);
    setState(() {
      _messages.addAll(msgs);
    });
    return _messages;
  }

  void _sendImage(bool inAlbum) async {
    var image = await ImagePicker.pickImage(
        source: inAlbum ? ImageSource.gallery : ImageSource.camera);
    var msg = await IMService.shared.sendImage(image.path, targetId,type);
    setState(() {
      _messages.insert(0, msg);
    });
    _resignAllFocus();
  }

//发送文本消息
  _sendText(String text) {
    IMService.shared.sendText(text, targetId, type).then((msg) {
      setState(() {
        _messages.insert(0, msg);
      });
    });
  }

  _resignAllFocus() {
    _inputControl.emojSelected = false;
    _inputControl.mediaSelected = false;
    _inputControl.resignFocus();
    setState(() {});
  }
}
