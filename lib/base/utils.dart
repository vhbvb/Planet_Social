import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:planet_social/common/image_preview.dart';

class Util {
  static Map<String,Color> colors = {};
  static randomColor({String key}) {
    _create() => Color.fromARGB(255, Random.secure().nextInt(135) + 120,
        Random.secure().nextInt(135) + 120, Random.secure().nextInt(135) + 120);

    if(key != null){
      if(colors[key] == null){
        colors[key] = _create();
      }
      return colors[key];
    }else{
      return _create();
    }
  }

  static Widget loadImage(String path, {double height, double width, bool enableTap = false, List sources, BuildContext context}) {
    return GestureDetector(
      onTap: (){
        if (enableTap){
        Navigator.of(context).push( FadeRoute(page: ImagePreview(
        images:sources,//传入图片list
        index: sources.indexOf(path),
        heroTag: "",//传入当前点击的图片的index
        //传入当前点击的图片的hero tag （可选）
    )));
        }
      },
      child: CachedNetworkImage(
      fit: BoxFit.fill,
      height: height,
      width: width,
      imageUrl: path,
      placeholder: (context, url) => SizedBox(
        height: height,
        width: width,
        child: Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      errorWidget: (context, url, error) => SizedBox(
        height: height,
        width: width,
        child: Center(child: Icon(Icons.error)),
      ),
    ),
    );
  }
}