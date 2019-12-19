import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './im_message_cellbuilder.dart';
import './im_input_bar.dart';
import './im_emoj.dart';
import './im_media.dart';
import 'package:image_picker/image_picker.dart';
import './im_order.dart';
import 'im_player_full.dart';
// import "";

class FTIMChat extends StatefulWidget {
  FTIMChat({Key key, this.uid}) : super(key: key);
  final uid;

  @override
  State<StatefulWidget> createState() => new _FTIMChatState();
}

class _FTIMChatState extends State<FTIMChat> with TickerProviderStateMixin {
  final _messages = [
    // "video:http://18471773.147.ctc.data.tv002.com:443/down/05df237b4f893272eaee52c24c7873d0-35315850/邓紫棋GEM%20《倒数》Live版%20%5BAV%2032908371%2C%20From%20JIJIDOWN.COM%5D.mp4?cts=dx-f-D61A174A15A216F97213&ctp=61A174A15A216&ctt=1540823046&limit=1&spd=1300000&ctk=9511f030fdb431954cccc0c7a83b216b&chk=05df237b4f893272eaee52c24c7873d0-35315850&mtd=1",
    "video:assets/imtable/daoshu.mp4",
    "voice:OurMemory.mp3",
    "我要穿越这片沙漠\n找寻真的自我\n身边只有一匹骆驼陪我",
    "这片风儿吹过\n那片云儿飘过\n突然之间出现爱的小河",
    "什么鬼魅传说,什么魑魅魍魉妖魔,只有那鹭鹰在幽幽的高歌",
    "我寻找沙漠绿洲,出现海市蜃楼,我仿佛看到她在那里等候,想起了她的温柔,滚烫着我的胸口,迷失在昨夜的那壶老酒",
    "我穿上大头皮鞋,跨过凛冽荒野,我仿佛穿越到另一个世界",
    "image:https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539760485134&di=c084367cff72982065835b1ef812b78a&imgtype=0&src=http%3A%2F%2Fpic.uzzf.com%2Fup%2F2018-2%2F15177108659009550.gif",
    "image:https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539760485134&di=c084367cff72982065835b1ef812b78a&imgtype=0&src=http%3A%2F%2Fpic.uzzf.com%2Fup%2F2018-2%2F15177108659009550.gif",
    "image:https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539760485134&di=c084367cff72982065835b1ef812b78a&imgtype=0&src=http%3A%2F%2Fpic.uzzf.com%2Fup%2F2018-2%2F15177108659009550.gif",
    "image:https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539760485134&di=c084367cff72982065835b1ef812b78a&imgtype=0&src=http%3A%2F%2Fpic.uzzf.com%2Fup%2F2018-2%2F15177108659009550.gif",
    "image:https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539841447069&di=7fa51a8b19ea6e63c6b2b58e6953bb79&imgtype=0&src=http%3A%2F%2Fimg.article.pchome.net%2F00%2F52%2F08%2F71%2Fpic_lib%2Fwm%2FJingxuan208.jpg",
    "image:https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539841536712&di=c0274d544454cf74864fbac3b6e61d9d&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01ca425a3a101ca801201a1f8ea667.jpg%401280w_1l_2o_100sh.jpg",
    "image:https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539841562258&di=72a379a5a77d22bb21f583f6f987559a&imgtype=0&src=http%3A%2F%2Fi6.download.fd.pchome.net%2Ft_640x1136%2Fg1%2FM00%2F08%2F13%2FooYBAFOVnHmIUYt_AABUKCsYhpsAABlsAB8Q3AAAFRA595.jpg",
    "我穿上大头皮鞋,跨过凛冽荒野,我仿佛穿越到另一个世界",
    "hem ~ ? 咋了 ~",
    "hello ~",
  ];

  final _scrollController = new ScrollController();
  FTIMChatInputControl _inputControl;
  FTIMMediaControl _mediaControl;
  FTIMChatOrder _order;
  MessageCellBuilder _cellBuilder;

  Widget _creatCell(int index) {
    bool send = index % 2 == 1 ? true : false;
    bool show = index % 3 == 0 ? true : false;

    return _cellBuilder.cell(_messages[index], send, show);
  }

  // double _safeAreaOffset(BuildContext context) {
  //   final size = MediaQuery.of(context).size;
  //   if (size.height / size.width > 2.0) {
  //     return 36.0;
  //   } else {
  //     return 0.0;
  //   }
  // }

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
    _cellBuilder = MessageCellBuilder(onImageDoubleClick: (String path) {
      Navigator.of(context)
          .push(PresentRoute(child: FTIMImagePreview(url: path)));
      // showCupertinoModalPopup(
      //   context: context,
      //   builder: (BuildContext context){
      //     return FTIMImagePreview(url:path);
      //   }
      // );
    }, onVideoDoubleClick: (String path) {
      print("Iam comming ~~");
      Navigator.of(context)
          .push(PresentRoute(child: FTIMVideoPreview(url: path)));
    });

    _inputControl = new FTIMChatInputControl(onFocusChange: (bool focus) {
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

    _mediaControl = new FTIMMediaControl(onAlbumClick: () {
      _getImage();
    }, onShootClick: () {
      _shoot();
    }, testFunc: (int index) {
      switch (index) {
        case 2:
          setState(() {
            _order.step = 0;
          });
          break;
        case 3:
          setState(() {
            _order.step = 1;
          });
          break;
        case 4:
          setState(() {
            _order.step = 2;
          });
          break;
        case 5:
          setState(() {
            _order.step = 3;
          });
          break;
        case 6:
          break;
        case 7:
          break;
        case 8:
          break;
        default:
          break;
      }
    });

    _order = new FTIMChatOrder(
        controller: new AnimationController(
            duration: const Duration(milliseconds: 250), vsync: this),
        onAnimation: () {
          setState(() {});
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new CupertinoPageScaffold(
        navigationBar: new CupertinoNavigationBar(
          middle: new Text("AnyKo",
              style: new TextStyle(
                  fontSize: 17.0, color: Color.fromARGB(255, 73, 73, 83))),
          leading: new GestureDetector(
              child:
                  new Image.asset("assets/back.png", height: 30.0, width: 30.0),
              onTap: () {
                Navigator.pop(context);
              }),
          // trailing: new GestureDetector(
          //     child: new Image.asset("assets/flutter.png",
          //         height: 20.0, width: 20.0),
          //         onTap: (){
          //           print("tap.....");
          //         },),
        ),
        child: Material(
          child: GestureDetector(
            onTap: (){
              _inputControl.emojSelected = false;
              _inputControl.mediaSelected = false;
              _inputControl.resignFocus();
              setState(() {
                              
                            });

            },
            child: new Stack(
            children: <Widget>[
              new SafeArea(
                  bottom: true,
                  child: new Column(children: <Widget>[
                    new Expanded(
                      child: new ListView.builder(
                          reverse: true,
                          controller: _scrollController,
                          itemCount: _messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _creatCell(index);
                          }),
                    ),
                    new Container(
                        constraints: new BoxConstraints(
                            minHeight: 50.0, maxHeight: 200.0),
                        child: new FTIMChatInput(
                          control: _inputControl,
                        )),
                    _creatExt()
                  ])),
              _order.createFold(context),
              _order.createUnfold(context)
            ],
          ),
          )
        ));
  }
}
