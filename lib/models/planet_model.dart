import 'dart:math';

import 'package:flutter/material.dart';
import 'package:planet_social/base/utils.dart';
import 'package:planet_social/models/user_model.dart';

class Planet 
{
  final String name = "某某兴趣星球";
  final User owner = User();
  final int fans = 122234;
  final Offset position = Offset(Random().nextDouble()*2000-1000,Random().nextDouble()*2000-1000);
  // final Offset position = Offset(0,0);
  // Planet(this.name, this.leader);
  final Color color = Util.randomColor();
}