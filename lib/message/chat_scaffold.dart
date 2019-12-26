import 'package:flutter/material.dart';
import 'package:planet_social/base/im_service.dart';
import 'package:planet_social/message/message_detail.dart';
import 'package:planet_social/models/user_model.dart';
import './im_input_bar.dart';
import './im_emoj.dart';
import './im_media.dart';
import 'package:image_picker/image_picker.dart';
import 'im_player_full.dart';


class ChatScaffold extends StatefulWidget {
  ChatScaffold({Key key, this.user}) : super(key: key);
  final User user;

  @override
  State<StatefulWidget> createState() =>  _ChatScaffoldState();
}

class _ChatScaffoldState extends State<ChatScaffold> with TickerProviderStateMixin {
  final _messages = [];

  final _scrollController = ScrollController();
  FTIMChatInputControl _inputControl;
  FTIMMediaControl _mediaControl;

  Widget _creatExt() {
    if (_inputControl.emojSelected) {
      print("------------------->1");
      return new FTIMEmoj();
    } else if (_inputControl.mediaSelected) {
      print("------------------->2");
      return new FTIMMedia(control: _mediaControl);
    } else {
      print("------------------->3");
      return new Container();
    }
  }

  void _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _messages.insert(0, "image:" + image.path);
    });
  }

  void _shoot() async {
    var file = await ImagePicker.pickImage(source: ImageSource.camera);
    print("---------------------->" + file.path);
    setState(() {
      _messages.insert(0, "image:" + file.path);
    });
  }

  @override
  void initState() {
    print("hahha");
    _setupVariables();
    _refresh();
    super.initState();
  }

  _setupVariables(){
// _cellBuilder = MessageCellBuilder(onImageClick: (String path) {
//       Navigator.of(context)
//           .push(PresentRoute(child: FTIMImagePreview(url: path)));
//     }, onVideoClick: (String path) {
//       print("Iam comming ~~");
//       Navigator.of(context)
//           .push(PresentRoute(child: FTIMVideoPreview(url: path)));
//     });

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
    }, onEmojItemChange: () {
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
      _messages.insert(0, text);
    });

    _mediaControl = FTIMMediaControl(onAlbumClick: () {
      _getImage();
    }, onShootClick: () {
      _shoot();
    }, testFunc: (int index) {

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.user.nickName,
              style: TextStyle(
                  fontSize: 17.0, color: Colors.black)),
          leading: GestureDetector(
              child:Padding(child: Image.asset("assets/back.png"),padding: EdgeInsets.all(10),),
              onTap: () {
                Navigator.pop(context);
              }),
        ),
        body: GestureDetector(
            onTap: (){
              _inputControl.emojSelected = false;
              _inputControl.mediaSelected = false;
              _inputControl.resignFocus();
              setState(() {});
            },
            child:  Stack(
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
                            return MessageDetail(_messages[index],
                            onImageClick: (){

                            },
                            onVideoClick: (){
                              
                            },);
                          }),
                    ),
                     Container(
                        constraints:  BoxConstraints(
                            minHeight: 50.0, maxHeight: 200.0),
                        child:  FTIMChatInput(
                          control: _inputControl,
                        )),
                    _creatExt()
                  ])),
            ],
          ),
          ));
  }

 Future _refresh({islocal = false}) async{
    _messages.clear();
    var msg =await IMService.shared.localMessagesList(widget.user.userId);
    setState(() {
       _messages.addAll(msg);
    });
    return msg;
  }
}
