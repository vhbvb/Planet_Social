import 'package:planet_social/models/user_model.dart';

class Comment {
  Comment();
  User owner;
  String id;
  String postId;
  String ownerId;
  String content;
  String createdAt;
  
  Map<String, dynamic> jsonMap() {
    Map<String, dynamic> map = Map();
    map["objectId"] = id;
    map["postId"] = postId;
    map["ownerId"] = ownerId;
    map["content"] = content;
    map["createdAt"] = createdAt;

    map.removeWhere((key, value) {
      return value == null || value == "null";
    });
    return map;
  }

  factory Comment.withJson(Map<String, dynamic> rawData) {
    Comment comment = Comment();
    comment.id = rawData["objectId"];
    comment.postId = rawData["postId"];
    comment.ownerId = rawData["ownerId"];
    comment.content = rawData["content"];
    comment.createdAt = rawData["createdAt"];
    return comment;
  }
}
