import 'package:flutter/material.dart';
import 'dart:math';

class Util {
  static randomColor() {
    return Color.fromARGB(
        255, 
        Random.secure().nextInt(135)+120,
        Random.secure().nextInt(135)+120, 
        Random.secure().nextInt(135)+120);
  }

  // static Image clip(Image image, Rect src){
    
  // }
}