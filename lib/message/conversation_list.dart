import 'dart:async';
import 'package:flutter/material.dart';
import 'package:planet_social/base/data_center.dart';
import 'package:planet_social/base/im_service.dart';
import 'package:planet_social/base/utils.dart';
import 'package:planet_social/const.dart';
import 'package:planet_social/models/user_model.dart';
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
  final List _conversations = [];
  final List<_ConversationDetailElements> _details = [];

  Widget _createConversations(int index) {
    var elem = _details[index];

    return GestureDetector(
      onTap: () {
        PSRoute.push(context, "chat_scaffold",elem.target);
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
          onLoad: null,
          child: ListView.builder(
            itemCount: _conversations.length,
            itemBuilder: (BuildContext context, int position) {
              return _createConversations(position);
            },
          ),
        ));
  }

  Future _refresh() async {
    _conversations.clear();
    _details.clear();
    var conversations = await IMService.shared.conversationList();

    for (var item in conversations) {
      var c = await _ConversationDetailElements(item).requestDetail();
      _details.add(c);
    }

    setState(() {
      _conversations.addAll(conversations);
    });
  }
}

class _ConversationDetailElements {
  final Conversation c;
  _ConversationDetailElements(this.c);

  String icon = Consts.defaultAvatar;
  String title = "";
  int unRead = 0;
  String des = "";
  String timesTamp = "";

  User target;

  Future<_ConversationDetailElements> requestDetail() async {
    unRead = await IMService.shared.unreadCount(c.conversationType, c.targetId);
    timesTamp = Util.timesTamp(DateTime.fromMillisecondsSinceEpoch(c.sentTime));

// class RCConversationType {
//   static const int Private = 1;
//   static const int Group = 3;
//   static const int ChatRoom = 4;
//   static const int System = 6;
// }

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

    var block = Completer();
    if (c.conversationType == RCConversationType.Private) {
      DataSource.center.getUser(c.targetId, (user, error) {
        target = user;
        icon = user.avatar;
        title = user.nickName;
        block.complete();
      });
    }

    await block.future;

    return this;
  }
}
