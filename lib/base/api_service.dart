import 'dart:convert';
import 'dart:io';
import 'package:planet_social/const.dart';
import 'package:planet_social/models/planet_model.dart';
import 'package:planet_social/models/post_model.dart';
import 'package:planet_social/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

enum RequestType {
  post,
  get,
  delete,
  put,
}

class ApiService {
  static ApiService shared = ApiService();
  void regist(User user, String password,
      Function(User, Map<String, dynamic> error) callback) {
    Map<String, dynamic> params = user.jsonMap();
    params["password"] = password;
    _send("users", params, RequestType.post).then((response) {
      if (response.statusCode ~/ 100 == 2) {
        //2xx
        if (callback != null) {
          callback(User.withJson(jsonDecode(response.body)), null);
        }
      } else {
        if (callback != null) {
          callback(null, jsonDecode(response.body));
        }
      }
    });
  }

  void updateUserInfo(
      User user, Function(Map<String, dynamic> error) callback) {
    Map<String, dynamic> params = user.jsonMap();
    _send("users/" + user.userId, params, RequestType.put).then((response) {
      if (response.statusCode ~/ 100 == 2) {
        if (callback != null) {
          callback(null);
        }
      } else {
        if (callback != null) {
          callback(jsonDecode(response.body));
        }
      }
    });
  }

  void login(User user, String password,
      Function(User, Map<String, dynamic> error) callback) {
    Map<String, dynamic> params = user.jsonMap();
    params["password"] = password;
    _send("login", params, RequestType.post).then((response) {
      if (response.statusCode ~/ 100 == 2) {
        //2xx
        if (callback != null) {
          callback(User.withJson(jsonDecode(response.body)), null);
        }
      } else {
        if (callback != null) {
          callback(null, jsonDecode(response.body));
        }
      }
    });
  }

  void getUser(
      String userid, Function(User, Map<String, dynamic> error) callback) {
    _send("users/" + userid, null, RequestType.get).then((response) {
      if (response.statusCode ~/ 100 == 2) {
        //2xx
        if (callback != null) {
          callback(User.withJson(jsonDecode(response.body)), null);
        }
      } else {
        if (callback != null) {
          callback(null, jsonDecode(response.body));
        }
      }
    });
  }

  void createPlanet(
      Planet planet, Function(Planet, Map<String, dynamic> error) callback) {
    _send("classes/planet", planet.jsonMap(), RequestType.post)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        //2xx
        if (callback != null) {
          callback(Planet.withJson(jsonDecode(response.body)), null);
        }
      } else {
        if (callback != null) {
          callback(null, jsonDecode(response.body));
        }
      }
    });
  }

  void updatePlanet(
      Planet planet, Function(Planet, Map<String, dynamic> error) callback) {
    _send("classes/planet/" + planet.id, planet.jsonMap(), RequestType.put)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        //2xx
        if (callback != null) {
          callback(Planet.withJson(jsonDecode(response.body)), null);
        }
      } else {
        if (callback != null) {
          callback(null, jsonDecode(response.body));
        }
      }
    });
  }

  void createPost(
      Post post, Function(Post, Map<String, dynamic> error) callback) {
    _send("classes/post", post.jsonMap(), RequestType.post).then((response) {
      if (response.statusCode ~/ 100 == 2) {
        //2xx
        if (callback != null) {
          callback(Post.withJson(jsonDecode(response.body)), null);
        }
      } else {
        if (callback != null) {
          callback(null, jsonDecode(response.body));
        }
      }
    });
  }

  void deletePost(Post post, Function(Map<String, dynamic> error) callback) {
    _send("classes/post/" + post.id, null, RequestType.delete).then((response) {
      if (response.statusCode ~/ 100 == 2) {
        //2xx
        if (callback != null) {
          callback(null);
        }
      } else {
        if (callback != null) {
          callback(jsonDecode(response.body));
        }
      }
    });
  }

  void uploadImage(String path, Function(String) callback) {
    _upload(File(path)).then((response) {
      response.stream.transform(utf8.decoder).listen((value) {
        if (response.statusCode ~/ 100 == 2) {
          callback(jsonDecode(value)["url"]);
        } else {
          callback(null);
        }
      });
    });
  }

  void likePost(
      User current, Post post, Function(Map<String, dynamic> error) callback) {
    _send("classes/post_like", {"userId": current.userId, "postId": post.id},
            RequestType.post)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        callback(null);
      } else {
        callback(jsonDecode(response.body));
      }
    });
  }

  void dislikePost(
      User current, Post post, Function(Map<String, dynamic> error) callback) {
    String uid = current.userId;
    String pid = post.id;
    _send(
            "classes/post_like/<objectId>?where=" +
                Uri.encodeFull('{"userId":$uid,"postId":$pid}'),
            null,
            RequestType.delete)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        callback(null);
      } else {
        callback(jsonDecode(response.body));
      }
    });
  }

  void likeUser(
      User current, User user, Function(Map<String, dynamic> error) callback) {
    _send("classes/user_like", {"sId": current.userId, "tId": user.userId},
            RequestType.post)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        callback(null);
      } else {
        callback(jsonDecode(response.body));
      }
    });
  }

  void dislikeUser(
      User current, User user, Function(Map<String, dynamic> error) callback) {
    String sid = current.userId;
    String tid = user.userId;

    _send(
            "classes/user_like/<objectId>?where=" +
                Uri.decodeFull('{"sId": $sid, "tId": $tid}'),
            null,
            RequestType.delete)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        callback(null);
      } else {
        callback(jsonDecode(response.body));
      }
    });
  }

  void likePlanet(User current, Planet planet,
      Function(Map<String, dynamic> error) callback) {
    _send("classes/planet_like",
            {"userId": current.userId, "planetId": planet.id}, RequestType.post)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        callback(null);
      } else {
        callback(jsonDecode(response.body));
      }
    });
  }

  void dislikePlanet(User current, Planet planet,
      Function(Map<String, dynamic> error) callback) {
    String uid = current.userId;
    String pid = planet.id;
    _send(
            "classes/planet_like/<objectId>?where=" +
                Uri.encodeFull('{"userId": $uid, "planetId": $pid}'),
            null,
            RequestType.post)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        callback(null);
      } else {
        callback(jsonDecode(response.body));
      }
    });
  }

  Future<http.StreamedResponse> _upload(File file) async {
    // open a bytestream
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    // get file length
    var length = await file.length();
    // string to uri
    var uri = Uri.parse(Consts.fileUploadUrl + "avartar.png");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(file.path));

    // add file to multipart
    request.files.add(multipartFile);
    request.headers["X-LC-Id"] = Consts.appID;
    request.headers["X-LC-Key"] = Consts.appKey;

    // send
    return await request.send();
  }

  Future<http.Response> _send(
      String path, Map<String, dynamic> params, RequestType reqType) async {
    var client = new http.Client();
    String url = Consts.baseUrl + path;
    http.Response response;

    try {
      Map<String, String> header = {
        "X-LC-Id": Consts.appID,
        "X-LC-Key": Consts.appKey,
        "Content-Type": "application/json"
      };
      switch (reqType) {
        case RequestType.post:
          response =
              await client.post(url, body: jsonEncode(params), headers: header);
          break;
        case RequestType.get:
          response = await client.get(url, headers: header);
          break;
        case RequestType.put:
          response =
              await client.put(url, body: jsonEncode(params), headers: header);
          break;
        case RequestType.delete:
          response = await client.delete(url, headers: header);
          break;
        default:
          break;
      }
    } finally {
      client.close();
    }

    return response;
  }
}
