import 'dart:async';
import 'dart:convert';
import 'package:planet_social/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:planet_social/models/user_model.dart';

class PSManager {
  static final PSManager shared = PSManager();

  User currentUser;

  int seconds = 60;
  Timer smsTimer;

  startSmsTimer(Function(int) callback) {
    seconds = 60;
    smsTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds = seconds - 1;
      if (seconds == 0) {
        timer.cancel();
      }
      callback(seconds);
    });
  }

  Future setUser(User user) async {
    if (user != null){
        currentUser = user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Consts.kUser, jsonEncode(currentUser.jsonMap()));
    }
  }

  Future<bool> get isLogin async {
    if (currentUser == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userJsonStr = prefs.getString(Consts.kUser);
      if (userJsonStr != null) {
        currentUser = User.withJson(jsonDecode(userJsonStr));
      }
    }

    return currentUser != null && currentUser.sessionToken != null;
  }
}
