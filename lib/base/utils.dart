import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:planet_social/common/image_preview.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class Util {
  static Map<String, Color> colors = {};
  static randomColor({String key}) {
    _create() => Color.fromARGB(255, Random.secure().nextInt(135) + 120,
        Random.secure().nextInt(135) + 120, Random.secure().nextInt(135) + 120);

    if (key != null) {
      if (colors[key] == null) {
        colors[key] = _create();
      }
      return colors[key];
    } else {
      return _create();
    }
  }

  static Widget loadImage(String path,
      {double height,
      double width,
      bool enablePreview = false,
      List sources,
      BuildContext context,
      Function onTap}) {
    Widget image;
    if (path.startsWith("http")) {
      image = CachedNetworkImage(
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
    } else if (path.startsWith("assets")) {
      image = Image.asset(path, fit: BoxFit.fill, height: height, width: width);
    } else {
      image = Image.file(File(path),
          fit: BoxFit.fill, height: height, width: width);
    }

    return GestureDetector(
      onTap: () {
        if (enablePreview) {
          Navigator.of(context).push(FadeRoute(
              page: ImagePreview(
            images: sources, //传入图片list
            index: sources.indexOf(path),
            heroTag: "", //传入当前点击的图片的index
          )));
        } else if (onTap != null) {
          onTap();
        }
      },
      child: image,
    );
  }

  static String timesTamp(DateTime date) {
    var y = date.year;
    var m = date.month;
    var d = date.day;
    var h = date.hour;
    var min = date.minute;
    var s = date.second;
    var now = DateTime.now();

    _str(int n) => n.toString().padLeft(2, "0");

    if (y == now.year) {
      if (d == now.day && m == now.month) {
        var dist_h = now.hour - h;

        if (dist_h <= 5) {
          if (dist_h > 0) {
            return "$dist_h 小时前";
          } else {
            var dist_min = now.minute - min;

            if (dist_min > 5) {
              return "$dist_min 分钟前";
            } else {
              return "刚刚";
            }
          }
        } else {
          return [_str(h), _str(min), _str(s)].join(":");
        }
      } else {
        return _str(m) + "-" + _str(d) + " " + _str(h) + ":" + _str(min);
      }
    } else {
      return [_str(y), _str(m), _str(d)].join("-");
    }
  }

  static setStatusBarStyle(bool white) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(white);
  }
}
