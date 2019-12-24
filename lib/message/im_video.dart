import 'package:planet_social/base/utils.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
// import 'dart:async';

class FTIMVideoControl {
  FTIMVideoControl({this.url, this.presentFullScreen}) : super();
  final String url;

  Function presentFullScreen;
}

class FIIMVideoPlayerSimple extends StatefulWidget{
  FIIMVideoPlayerSimple({this.control}) : super();
  final control;
  @override
  State<StatefulWidget> createState() =>
      _FIIMVideoPlayerSimpleState(control: control);
}

// 保活
class _FIIMVideoPlayerSimpleState extends State<FIIMVideoPlayerSimple> with AutomaticKeepAliveClientMixin {
  _FIIMVideoPlayerSimpleState({this.control}) : super();

  final FTIMVideoControl control;

  VideoPlayerController vp;

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    // TODO: implement initState
    print("----------initState");

    if (vp == null){
      if (control.url.startsWith("http")) {
        vp = VideoPlayerController.network(control.url)..addListener(() {});
      } else {
        vp = VideoPlayerController.asset(control.url)..addListener(() {});
      }

          // vp.play();
      vp.setLooping(true);
      vp.initialize().then((_) {
        // print("initialize finish=====================");
        // print(vp);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    vp.dispose();
    print("----------dispose");
    super.dispose();
  }

  @override
    void deactivate() {
      // TODO: implement deactivate
      // vp.dispose();
      print("----------deactivate");
      super.deactivate();
    }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (vp.value.initialized && vp.value.isPlaying)
        ? AspectRatio(
            aspectRatio: vp.value.aspectRatio,
            child: new GestureDetector(
                onTap: () {
                  if (vp.value.isPlaying) {
                    vp.pause();
                  } else {
                    vp.play();
                  }
                },
                onDoubleTap: () {
                  vp.pause();
                  control.presentFullScreen();
                },
                child: VideoPlayer(vp)),
          )
        : GestureDetector(
            onTap: () {
              if (vp.value.initialized) {
                vp.play();
                setState(() {});
              } else {
                print("还在缓冲...");
              }
            },
            child: new Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Util.loadImage(
                    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1573561281761&di=896c69de357831f686ea3f7e0b846244&imgtype=0&src=http%3A%2F%2Fi2.letvimg.com%2Fvrs%2F201409%2F03%2Ffda8fc43-c8ad-4358-ab30-e49327b5d8f8.jpg"),
                Image.asset("assets/im_player.png")
              ],
            ),
          );
  }
}
