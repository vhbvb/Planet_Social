import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';

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

  static Widget loadImage(String path, {double height, double width}) {
    return CachedNetworkImage(
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
    );
  }
}