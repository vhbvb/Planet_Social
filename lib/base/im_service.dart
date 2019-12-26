import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:planet_social/const.dart';
import 'package:planet_social/models/user_model.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
import 'package:http/http.dart' as http;

class IMService {
  static final shared = IMService();

  Future<Message> sendText(String text, String uid) async {
    var txtMessage = TextMessage()..content = text;
    return await RongcloudImPlugin.sendMessage(
        RCConversationType.Private, uid, txtMessage);
  }

  sendImage(String path, String uid) async {
    var imgMessage = ImageMessage()..localPath = path;
    return await RongcloudImPlugin.sendMessage(
        RCConversationType.Private, uid, imgMessage);
  }

  sendVideo(String path, int duration, String uid) async {
    SightMessage sightMessage = SightMessage.obtain(path, duration);
    return await RongcloudImPlugin.sendMessage(
        RCConversationType.Private, uid, sightMessage);
  }

  start() {
    RongcloudImPlugin.onMessageReceived = (Message msg, int left) {
      print("receive message messsageId:" +
          msg.messageId.toString() +
          " left:" +
          left.toString());
    };
  }

  Future<List<dynamic>> conversationList() async {
    return await RongcloudImPlugin.getConversationList([
      RCConversationType.Private,
      RCConversationType.Group,
      RCConversationType.System
    ]);
  }

  Future<bool> removeConversation(String cid) async {
    var c = Completer();
    bool res = false;
    RongcloudImPlugin.removeConversation(RCConversationType.Private, cid,
        (success) {
      res = success;
      c.complete();
    });
    await c.future;
    return res;
  }

  Future<List<dynamic>> localMessagesList(String uid,{int type = 1,int messageId=0}) async {
    return await RongcloudImPlugin.getHistoryMessage(type, uid, 0, 20);
  }

   Future<List<dynamic>> remoteMessagesList(String uid,{int type = 1}) async {
     var c  =Completer();
     List msgs = [];
    RongcloudImPlugin.getRemoteHistoryMessages(type, uid, 0, 100,(List msgList,int code) {

      if(code == 0) 
      {
        msgs.addAll(msgList);
      }else{
        print("errorCode:"+code.toString());
      }
      c.complete();
    });

    await c.future;

    return msgs;
  }

  Future<bool> joinChatRoom(String rid) async {
    RongcloudImPlugin.joinChatRoom(rid, 10);
    var c = Completer();
    int res = 0;
    RongcloudImPlugin.onJoinChatRoom = (String targetId, int status) {
      if (targetId == rid) {
        res = status;
      }
      c.complete();
    };
    await c.future;
    return res == RCOperationStatus.Success;
  }

  Future<bool> quitChatRoom(String rid) async {
    RongcloudImPlugin.quitChatRoom(rid);
    var c = Completer();
    int res = 0;
    RongcloudImPlugin.onQuitChatRoom = (String targetId, int status) {
      if (targetId == rid) {
        res = status;
      }
      c.complete();
    };
    await c.future;
    return res == RCOperationStatus.Success;
  }

  Future<ChatRoomInfo> chatRoomInfo(String rid) async {
    return await RongcloudImPlugin.getChatRoomInfo(
        rid, 10, RCChatRoomMemberOrder.Desc);
  }

  Future<int> unreadCount(int type, String cid) async {
    var c = Completer();
    int res = 0;
    RongcloudImPlugin.getUnreadCount(type, cid, (int count, int code) {
      res = count;
      c.complete();
    });
    await c.future;
    return res;
  }

  Future<int> totalUnreadCount() async {
    var c = Completer();
    int res = 0;
    RongcloudImPlugin.getTotalUnreadCount((int count, int code) {
      res = count;
      c.complete();
    });
    await c.future;
    return res;
  }

  void loginIM(
      User user, Function(String, Map<String, dynamic> error) callback) {
    var params = {
      "userId": user.userId,
      "name": user.nickName == null ? "null" : user.nickName,
      "portraitUri": user.avatar == null ? Consts.defaultAvatar : user.avatar
    };

    _send("user/getToken", params).then((resp) {
      var info = jsonDecode(resp.body);
      if (resp.statusCode == 200) {
        callback(info["token"], null);
      } else {
        callback(null, info);
      }
    });
  }

  void createChatRoom(String starId, String name,
      Function(Map<String, dynamic> error) callback) {
    var params = {"chatroom[$starId]": name};

    _send("chatroom/create", params).then((resp) {
      var info = jsonDecode(resp.body);
      if (resp.statusCode == 200) {
        callback(null);
      } else {
        callback(info);
      }
    });
  }

  Future<http.Response> _send(
      String category, Map<String, dynamic> params) async {
    var url = "https://api-cn.ronghub.com/$category.json";
    var client = http.Client();
    http.Response response;

    try {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String nonce = Random().nextDouble().toString();
      String signSource = (Consts.imSecret + nonce + timestamp);
      var sign = sha1.convert(utf8.encode(signSource));
      Map<String, String> header = {
        "App-Key": Consts.imKey,
        "Nonce": nonce,
        "Timestamp": timestamp,
        "Content-Type": "application/x-www-form-urlencoded",
        "Signature": sign.toString()
      };

      var paramsStr = params.entries.map((e) {
        return e.key + "=" + Uri.encodeFull(e.value);
      }).join("&");

      response = await client.post(url, body: paramsStr, headers: header);
    } finally {
      client.close();
    }

    return response;
  }
}

// 黑名单
// 把用户加入黑名单

// RongcloudImPlugin.addToBlackList(blackUserId, (int code) {
//       print("_addBlackList:" + blackUserId + " code:" + code.toString());
//     });
// 把用户移除黑名单

// RongcloudImPlugin.removeFromBlackList(blackUserId, (int code) {
//       print("_removeBalckList:" + blackUserId + " code:" + code.toString());
//     });
// 查询特定用户的黑名单状态

// RongcloudImPlugin.getBlackListStatus(blackUserId,
//         (int blackStatus, int code) {
//       if (0 == code) {
//         if (RCBlackListStatus.In == blackStatus) {
//           print("用户:" + blackUserId + " 在黑名单中");
//         } else {
//           print("用户:" + blackUserId + " 不在黑名单中");
//         }
//       } else {
//         print("用户:" + blackUserId + " 黑名单状态查询失败" + code.toString());
//       }
//     });
// 查询已经设置的黑名单列表

// RongcloudImPlugin.getBlackList((List/*<String>*/ userIdList, int code) {
//       print("_getBlackList:" + userIdList.toString() + " code:" + code.toString());
//       userIdList.forEach((userId) {
//         print("userId:"+userId);
//       });
//     });
