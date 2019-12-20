import 'dart:convert';
import 'package:planet_social/models/user_model.dart';

class Post {
  Post();
  User owner;
  String id;
  // String parentId;
  String ownerId;
  String content;
  List images;

  String starTitle;
  String starId;
  String createdAt;

  // int comments = 212121;

  Map<String, dynamic> jsonMap() {
    Map<String, dynamic> map = Map();
    map["objectId"] = id;
    // map["parentId"] = parentId;
    map["ownerId"] = ownerId;
    map["content"] = content;
    map["images"] = jsonEncode(images);
    map["starTitle"] = starTitle;
    map["starId"] = starId;
    // map["comments"] = comments;
    map["createdAt"] = createdAt;

    map.removeWhere((key, value) {
      return value == null || value == "null";
    });
    return map;
  }

  factory Post.withJson(Map<String, dynamic> rawData) {
    Post post = Post();
    post.id = rawData["objectId"];
    // post.parentId = rawData["parentId"];
    post.ownerId = rawData["ownerId"];
    post.content = rawData["content"];
    if (rawData["images"] != null) {
      post.images = jsonDecode(rawData["images"]);
    }
    post.starTitle = rawData["starTitle"];
    post.starId = rawData["starId"];
    post.createdAt = rawData["createdAt"];
    return post;
  }
}
