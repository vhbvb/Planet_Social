import 'dart:async';
import 'package:flutter/material.dart';
import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/base/data_center.dart';
import 'package:planet_social/base/im_service.dart';
import 'package:planet_social/base/manager.dart';
import 'package:planet_social/base/utils.dart';
import 'package:planet_social/const.dart';
import 'package:planet_social/route.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:planet_social/message/conversation_detail.dart';

class ConversationList extends StatefulWidget {
  final title = "消息";
  Function refresh;

  @override
  State<StatefulWidget> createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  List _conversations = [];
  List<_ConversationDetailElements> _details = [];

  Widget _createConversations(int index) {
    var elem = _details[index];

    return GestureDetector(
      onTap: () {
        PSRoute.push(context, "chat_scaffold", elem.target);
      },
      behavior: HitTestBehavior.opaque,
      child: ConversationDetail(
        icon: elem.icon,
        title: elem.title,
        des: elem.des,
        unreadCount: elem.unRead,
        updateAt: elem.timesTamp,
      ),
    );
  }

  @override
  void initState() {
    widget.refresh = _refresh;
    _refresh();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text("消息", style: TextStyle(fontSize: 17.0, color: Colors.black)),
        ),
        // backgroundColor: Colors.green,
        body: EasyRefresh(
          onRefresh: _refresh,
          onLoad: () {
            return;
          },
          child: ListView.builder(
            itemCount: _conversations.length,
            itemBuilder: (BuildContext context, int position) {
              return _createConversations(position);
            },
          ),
        ));
  }

  Future _refresh() async {
    if (PSManager.shared.currentUser != null) {
      _conversations = await _loadMessages();
      _details = [];
      for (var item in _conversations) {
        var c = await _ConversationDetailElements(item).requestDetail();
        _details.add(c);
      }
      setState(() {
        // print("_details:$_details");
      });
    }

    return _conversations;
  }
}

Future _loadMessages() async {
  var conversations = await IMService.shared.conversationList();
  if (conversations == null) {
    conversations = [];
  }

  var c = Completer();
  ApiService.shared.planetsJoined(PSManager.shared.currentUser,
      (results, error) {
    if (error == null) {
      for (var planet in results) {
        bool exist = false;
        for (var conv in conversations) {
          if (conv.conversationType == RCConversationType.ChatRoom &&
              conv.targetId == planet.id) {
            exist = true;
            break;
          }
        }

        if (!exist) {
          Conversation conv = Conversation();
          conv.conversationType = RCConversationType.ChatRoom;
          conv.targetId = planet.id;
          conversations.add(conv);
        }
      }
    }
    c.complete();
  });
  await c.future;
  return conversations;
}

class _ConversationDetailElements {
  final Conversation c;
  _ConversationDetailElements(this.c);

  String icon = Consts.defaultAvatar;
  String title = "";
  int unRead = 0;
  String des = "";
  String timesTamp = "";

  dynamic target;

  Future<_ConversationDetailElements> requestDetail() async {
    unRead = await IMService.shared.unreadCount(c.conversationType, c.targetId);
    if (c.sentTime != null) {
      timesTamp =
          Util.timesTamp(DateTime.fromMillisecondsSinceEpoch(c.sentTime));
    }

    if (c.latestMessageContent != null) {
      if (c.latestMessageContent is TextMessage) {
        des = (c.latestMessageContent as TextMessage).content;
      }

      if (c.latestMessageContent is VoiceMessage) {
        des = "[音频]";
      }

      if (c.latestMessageContent is SightMessage) {
        des = "[视频]";
      }

      if (c.latestMessageContent is ImageMessage) {
        des = "[图片]";
      }
    } else {
      des = "快来说点什么吧";
    }

    var block = Completer();
    if (c.conversationType == RCConversationType.Private) {
      DataSource.center.getUser(c.targetId, (user, error) {
        target = user;
        icon = user.avatar;
        title = user.nickName;
        block.complete();
      });
    }

    if (c.conversationType == RCConversationType.ChatRoom) {
      DataSource.center.getPlanet(c.targetId, (planet, error) {
        target = planet;
        icon = "assets/star_icon.png";
        title = planet.title + " 聊天室";
        block.complete();
      });
    }

    await block.future;

    return this;
  }
}
