import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:planet_social/base/im_service.dart';
import 'package:planet_social/const.dart';
import 'package:planet_social/route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:planet_social/models/user_model.dart';
import 'package:sharesdk_plugin/sharesdk_plugin.dart';
import 'package:sharesdk_plugin/sharesdk_register.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';

class PSManager {
  static final PSManager shared = PSManager();

  User currentUser;
  BuildContext mainContext;

  int seconds = 60;
  Timer smsTimer;
  List<User> blocks = [];

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
    if (user != null) {
      currentUser = user;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(Consts.kUser, jsonEncode(currentUser.jsonMap()));
    }
  }

  logout() async {
    currentUser = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    RongcloudImPlugin.disconnect(false);
    this.login();
  }

  login() async {
    if (currentUser == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userJsonStr = prefs.getString(Consts.kUser);
      if (userJsonStr != "null" && userJsonStr != null) {
        currentUser = User.withJson(jsonDecode(userJsonStr));
      }
    }

    var islogin = currentUser != null && currentUser.sessionToken != null;

    if (!islogin) {
      var complete = Completer();
      PSRoute.push(mainContext, "login", () {
        islogin = true;
        complete.complete();
      });
      await complete.future;
    }

    _didLogined();
    return islogin;
  }

  void registThirdParty() {
    _registShare();
    _registIM();
  }

  void _registShare() {
    ShareSDKRegister register = ShareSDKRegister();
    register.setupWechat("wx21884a47dd15db97",
        "c9cae1bb81cbbe667337ad6865319397", "https://ybpre.share2dlink.com/");
    register.setupSinaWeibo("2441761832", "bfddca47be05cb5289a00a24796a0497",
        "http://www.sharesdk.cn");
    register.setupQQ("101848818", "4adcfb7c037937615494d223efff62c1");
    // register.setupFacebook(
    //     "1412473428822331", "a42f4f3f867dc947b9ed6020c2e93558", "shareSDK");
    // register.setupTwitter("viOnkeLpHBKs6KXV7MPpeGyzE",
    //     "NJEglQUy2rqZ9Io9FcAU9p17omFqbORknUpRrCDOK46aAbIiey", "http://mob.com");
    //注册
    SharesdkPlugin.regist(register);
  }

  void _registIM() {
    RongcloudImPlugin.init(Consts.imKey);
  }

  void _didLogined() {

    PSRoute.me.refresh();
    PSRoute.myPlanet.refresh();
    IMService.shared.loginIM(currentUser, (token, error) {
      if (error == null) {
        currentUser.imToken = token;
        _connectIM();
      }
    });
  }

  void _addBlock(){
    
  }

  void _connectIM() {
    RongcloudImPlugin.connect(currentUser.imToken).then((r) {
      if (r == 0) {
        print("IM connected");
        IMService.shared.start();
        PSRoute.message.refresh();
      } else {
        print("IM connect failed code:" + r.toString());
      }
    });
  }

  void refreshUserinfo() {
    PSRoute.me.refresh();

    IMService.shared.loginIM(currentUser, (token, error) {
      if (error == null) {
        currentUser.imToken = token;
        _connectIM();
      }
    });
  }
}
