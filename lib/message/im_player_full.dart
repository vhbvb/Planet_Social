import 'package:flutter/material.dart';
import 'package:planet_social/base/utils.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import "package:flutter/cupertino.dart";

class PresentRoute extends CupertinoPageRoute{

  final Widget child;
  PresentRoute({this.child}):super(builder:(BuildContext context) => child,fullscreenDialog:true);
  
  @override
    Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      return super.buildTransitions(context, animation, secondaryAnimation, child);
    }
} 

class FTIMImagePreview extends StatefulWidget {
  FTIMImagePreview({this.url}):super();
final String url;
@override
  State<StatefulWidget> createState() => _FTIMImagePreviewState(url:url);
}

class _FTIMImagePreviewState extends State<FTIMImagePreview> {
  _FTIMImagePreviewState({this.url}):super();
final String url;
  @override
    Widget build(BuildContext context) {
    Widget image;
    if (url.startsWith("http")) 
    {
      image = Util.loadImage(url);
    }
    else
    {
      image =new Image.file(new File(url));
    }
      return  Transform.scale(
        origin: Offset.zero,
        scale: 1.0,
        child:  GestureDetector(
          onDoubleTap: (){

          },

          onTap: (){
            Navigator.of(context).pop();
          },

          child:  Container(
            color: Colors.black,
            child: image,            
          ),
        ),
      );
    }
}


class FTIMVideoPreview extends StatefulWidget{
  FTIMVideoPreview({this.url}):super();
final String url;
@override
  State<StatefulWidget> createState() => _FTIMVideoPreviewState(url: url);
}

class _FTIMVideoPreviewState extends State<FTIMVideoPreview> {
_FTIMVideoPreviewState({this.url}):super();

VideoPlayerController vp;
final String url;

@override
  void initState() {
      if (url.startsWith("http")) {
        vp = VideoPlayerController.network(url)..addListener(() {});
      } else {
        vp = VideoPlayerController.asset(url)..addListener(() {});
      }
      vp.setLooping(true);
      vp.initialize().then((_) {
        print(vp.value.size);
        setState(() {
                  vp.play();
                });
      });

      vp.addListener((){
        print(vp.value.position);

      });
    super.initState();
  }
  @override
    Widget build(BuildContext context) {
return (vp.value.initialized)
        ? Stack(
          alignment: Alignment.center,
          children: <Widget>[
            AspectRatio(
            aspectRatio:vp.value.aspectRatio,
            child: new GestureDetector(
                onTap: () {
                  if (vp.value.isPlaying) {
                    vp.pause();
                  } else {
                    vp.play();
                  }
                },
                onDoubleTap: () {
                  Navigator.of(context).pop();
                },
                child: VideoPlayer(vp)
                ),
        )
          ],
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
                    "http://i2.letvimg.com/vrs/201409/03/fda8fc43-c8ad-4358-ab30-e49327b5d8f8.jpg"),
                Image.asset("assets/im_player.png")
              ],
            ),
          );
    }

      @override
  void dispose() {
    vp.dispose();
    print("----------dispose");
    super.dispose();
  }
}
