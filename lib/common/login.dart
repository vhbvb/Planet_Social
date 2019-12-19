import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:mobsms/mobsms.dart";
import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/base/manager.dart';
import 'package:planet_social/common/PSAlert.dart';
import 'package:planet_social/common/PSProcess.dart';
import 'package:planet_social/models/user_model.dart';
import 'package:planet_social/route.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  var phoneController = TextEditingController();
  var verifyCodeController = TextEditingController();

  _getVerifyCode(){
    Smssdk.getTextCode(phoneController.text, "86", null, (ret,error){
      if(error != null){
        PSAlert.show(context, "验证码获取失败", error.toString());
      }else{
        PSManager.shared.startSmsTimer((s){
          // print(s);
          setState(() {});
        });
      }
    });
  }

  _login(){

    PSProcess.show(context);

    CircularProgressIndicator();
    // Smssdk.commitCode(phoneController.text, "86", verifyCodeController.text, (ret,error){
    //   if(error != null){
    //     PSProcess.dismiss(context);
    //     PSAlert.show(context, "验证码验证失败", error.toString());
    //   }else{
        ApiService.shared.login(User()..phone=phoneController.text, (User user,Map<String,dynamic> error){
          print(user != null ? user.jsonMap():error.toString());
          PSProcess.dismiss(context);
          if(user != null){
            PSManager.shared.setUser(user).then((_){
              
              // 第一次注册，性别参数是空的
              if(user.sex == null)
              {
                PSRoute.push(context, "user_settings", user,replace: true);  
              }else
              {
                PSRoute.pop(context);
              }
            });
          }else{
            PSAlert.show(context, "登录失败", error.toString());
          }
        });
    //   }
    // });
  }

  _verifyCodeInterface(){
    if(PSManager.shared.smsTimer!=null && PSManager.shared.smsTimer.isActive){
      return  MaterialButton(
                    onPressed: (){},
                    child: Text(PSManager.shared.seconds.toString()+"s后重新获取",
                        style:
                            TextStyle(color: Color(0xFFFF8776), fontSize: 16)),
                  );
    }else{
         return MaterialButton(
                    onPressed: _getVerifyCode,
                    child: Text("获取验证码",
                        style:
                            TextStyle(color: Color(0xFFFF8776), fontSize: 16)),
                  );
    }
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage("assets/star/star.jpeg"),
                fit: BoxFit.fill)),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.red),
              height: 86,
              width: 86,
            ),
            Padding(padding: EdgeInsets.only(bottom: 13)),
            Text(
              "星球",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            Padding(padding: EdgeInsets.only(bottom: 5)),
            Text(
              "找到属于你的世界",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            Padding(padding: EdgeInsets.only(bottom: 30)),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(23)),
                  color: Color(0xff404040)),
              height: 46,
              width: MediaQuery.of(context).size.width - 60,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text("手机号",
                        style: TextStyle(
                            color: Colors.white.withAlpha(256 ~/ 2),
                            fontSize: 16)),
                  ),
                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      style: TextStyle(color: Colors.white),
                      maxLength: 11,
                      cursorColor: Colors.white,
                      buildCounter: (BuildContext context,
                              {int currentLength,
                              int maxLength,
                              bool isFocused}) =>
                          null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(23)),
                  color: Color(0xff404040)),
              height: 46,
              width: MediaQuery.of(context).size.width - 60,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text("验证码",
                        style: TextStyle(
                            color: Colors.white.withAlpha(256 ~/ 2),
                            fontSize: 16)),
                  ),
                  Expanded(
                    child: TextField(
                      controller: verifyCodeController,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      maxLength: 6,
                      buildCounter: (BuildContext context,
                              {int currentLength,
                              int maxLength,
                              bool isFocused}) =>
                          null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  _verifyCodeInterface()
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 46)),
            GestureDetector(
              onTap: _login,
              child:             Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(23)),
                  color: Color(0xffFF8367)),
              height: 46,
              width: MediaQuery.of(context).size.width * 0.4,
              child: Text(
                "登录/注册",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 133, left: 100, right: 100),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ClipOval(
                      child: Image.asset(
                        "assets/微信图标.png",
                        height: 36,
                        width: 36,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipOval(
                      child: Image.asset(
                        "assets/QQ图标.png",
                        height: 36,
                        width: 36,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipOval(
                      child: Image.asset(
                        "assets/微博图标.png",
                        height: 36,
                        width: 36,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
