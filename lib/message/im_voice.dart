import "package:audioplayers/audioplayers.dart";
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class FTIMVoiceSimple extends StatefulWidget {
  FTIMVoiceSimple({this.control}):super();

  @required
  final FTIMVoiceControl control;
  @override
    State<StatefulWidget> createState() => _FTIMVoiceSimpleState(control: control);
}

class _FTIMVoiceSimpleState extends State<FTIMVoiceSimple> with TickerProviderStateMixin{
  _FTIMVoiceSimpleState({this.control}):super();

  // @override
    // TODO: implement wantKeepAlive
    // bool get wantKeepAlive => true;

    final FTIMVoiceControl control;

    AnimationController _animationControl;
    Animation<double> _animation;
    AudioCache _audioCache;
    AudioPlayer _audioPlayer;

    Future _play() async{
      Future<AudioPlayer> result = _audioCache.play(control.url,volume: 1.0);

      result.then((AudioPlayer player){

        print(player);
        // if (value == 1){
          _animationControl.repeat();
        //   print("player begin:"+ control.url);
        // }
        // else
        // {
        //   print("Play fail,state:" + value.toString());
        // }
      });
    }

    Future _stop() async{
      Future<int> result = _audioPlayer.stop();

      result.then((int value){

        // print(player);
        if (value == 1){
          _animationControl.stop();
        }
        else
        {
          print("stop fail,state:" + value.toString());
        }
      });
    }

    String _imageAssetName(){

      String name = control.isSend ? "msg_send_voice_":"msg_recv_voice_";

      name = "assets/" + name;
      
      if(_animationControl.isAnimating)
      {
        name += (_animation.value*4 + 1).toInt().toString();
      }
      else
      {
        name += "4";
      }

      name += ".png";
      return name;
    }

    @override
      void dispose() {
        // TODO: implement dispose
        _animationControl.dispose();
        _audioPlayer.release();
        super.dispose();
      }

    @override
      void initState() {
        // TODO: implement initState
        _audioPlayer = AudioPlayer();

        _audioCache = AudioCache(
          fixedPlayer: _audioPlayer
        );
        // AudioPlayer.logEnabled = true;
        _audioPlayer.completionHandler = (){
          _animationControl.stop();
          setState(() {
                      
                    });
        };

        _audioPlayer.errorHandler = (String text){
          print("error:"+text);
        };

        _animationControl = AnimationController(
          duration: Duration(seconds: 2),
          vsync: this,
          // animationBehavior: AnimationBehavior.preserve
        );

        _animation = CurvedAnimation(
          curve: Curves.linear,
          parent: _animationControl
        )..addListener((){
          setState(() {
                      
                    });
        });

        super.initState();
      }


  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new GestureDetector(
          onTap: (){
            if (_animationControl.isAnimating){
              _stop();
            }
            else
            {
              _play();
            }

          },
          child: new Container(
          // color: Colors.red,
          height: 10.0,
          width: 10.0,
          child: new Image.asset(_imageAssetName()),
        ),
      );
    }
}

class FTIMVoiceControl {
  FTIMVoiceControl({this.url,this.isSend}):super();
  final String url;
  final bool isSend;
}