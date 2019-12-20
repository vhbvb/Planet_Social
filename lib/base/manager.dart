import 'dart:async';
import 'dart:convert';
import 'package:planet_social/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:planet_social/models/user_model.dart';
import 'package:sharesdk_plugin/sharesdk_plugin.dart';
import 'package:sharesdk_plugin/sharesdk_register.dart';

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

  void registThirdParty(){

    ShareSDKRegister register = ShareSDKRegister();

      register.setupWechat(
          "wx617c77c82218ea2c", "c7253e5289986cf4c4c74d1ccc185fb1","https://www.sandslee.com/");


      register.setupSinaWeibo("568898243", "38a4f8204cc784f81f9f0daaf31e02e3",
          "http://www.sharesdk.cn");
      register.setupQQ("100371282", "aed9b0303e3ed1e27bae87c33761161d");
      register.setupFacebook(
          "1412473428822331", "a42f4f3f867dc947b9ed6020c2e93558", "shareSDK");
      register.setupTwitter("viOnkeLpHBKs6KXV7MPpeGyzE",
          "NJEglQUy2rqZ9Io9FcAU9p17omFqbORknUpRrCDOK46aAbIiey", "http://mob.com");

      //注册
      SharesdkPlugin.regist(register);
  }
}
