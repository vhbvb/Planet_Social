import 'dart:convert';
import 'dart:io';
import 'package:planet_social/base/data_center.dart';
import 'package:planet_social/base/manager.dart';
import 'package:planet_social/const.dart';
import 'package:planet_social/models/comment_model.dart';
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

  void login(User user,
      Function(User, Map<String, dynamic> error) callback) {
    Map<String, dynamic> params = user.jsonMap();

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

  void getPlanet(
      String pid, Function(Planet, Map<String, dynamic> error) callback) {
    _send("classes/planet/" + pid, null, RequestType.get).then((response) {
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

  void _getUsers(Function(List<User>, Map<String, dynamic> error) callback) {
    _send("users", null, RequestType.get).then((response) {
      if (response.statusCode ~/ 100 == 2) {
        //2xx
        if (callback != null) {
          List<dynamic> elems = jsonDecode(response.body)["results"];
          var models = elems.map((map) {
            return User.withJson(map);
          }).toList();
          callback(models, null);
        }
      } else {
        if (callback != null) {
          callback(null, jsonDecode(response.body));
        }
      }
    });
  }

  void _getPlanets(
      Function(List<Planet>, Map<String, dynamic> error) callback) {
    _send("classes/planet", null, RequestType.get).then((response) {
      if (response.statusCode ~/ 100 == 2) {
        //2xx
        if (callback != null) {
          List<dynamic> elems = jsonDecode(response.body)["results"];
          var models = elems.map((map) {
            return Planet.withJson(map);
          }).toList();
          callback(models, null);
        }
      } else {
        if (callback != null) {
          callback(null, jsonDecode(response.body));
        }
      }
    });
  }

  void getExploreItems(
      Function(List<User> users, List<Planet> planets,
              Map<String, dynamic> error)
          callback) {
    _getUsers((users, error) {
      if (users != null) {
        _getPlanets((planets, error) {
          if (planets != null) {
            planets = planets.map((p) {
              for (var user in users) {
                if (user.userId == p.ownerId) {
                  p.owner = user;
                }
              }
              return p;
            }).toList();
            callback(
              users,
              planets,
              null,
            );
          } else {
            callback(null, null, error);
          }
        });
      } else {
        callback(null, null, error);
      }
    });
  }

  void _queryUser(
      User user, Function(User, Map<String, dynamic> error) callback) {
    String query = jsonEncode(user.jsonMap());

    _send("users?where=" + query, null, RequestType.get).then((response) {
      if (response.statusCode ~/ 100 == 2) {
        //2xx
        if (callback != null) {
          List users = jsonDecode(response.body)["results"];
          if (users.length == 0) {
            callback(null, null);
          } else {
            callback(User.withJson(users.first), null);
          }
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

  void getNewPostOfPlanet(Planet planet,
      Function(List<Post>, Map<String, dynamic> error) callback) {
    String query = jsonEncode((Post()..starId = planet.id).jsonMap());
    _getPosts(query, callback);
  }

  void getHotPostOfPlanet(Planet planet,
      Function(List<Post>, Map<String, dynamic> error) callback) {
    String query = jsonEncode((Post()..starId = planet.id).jsonMap());
    _getPosts(query, callback);
  }

  void getPostOfUser(
      User user, Function(List<Post>, Map<String, dynamic> error) callback) {
    String query = jsonEncode((Post()..ownerId = user.userId).jsonMap());
    _getPosts(query, callback);
  }

  void _getPosts(
      String query, Function(List<Post>, Map<String, dynamic> error) callback) {
    _send("classes/post?where=" + query, null, RequestType.get)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        //2xx
        if (callback != null) {
          List posts = jsonDecode(response.body)["results"];
          callback(posts.map((item) => Post.withJson(item)).toList(), null);
        }
      } else {
        if (callback != null) {
          callback(null, jsonDecode(response.body));
        }
      }
    });
  }

    void createComment(
      Comment comment, Function(Comment, Map<String, dynamic> error) callback) {
    _send("classes/comment", comment.jsonMap(), RequestType.post).then((response) {
      if (response.statusCode ~/ 100 == 2) {
        //2xx
        if (callback != null) {
          callback(Comment.withJson(jsonDecode(response.body)), null);
        }
      } else {
        if (callback != null) {
          callback(null, jsonDecode(response.body));
        }
      }
    });
  }

void getCommentsOfPost(
      Post post, Function(List<Comment>, Map<String, dynamic> error) callback) { 
    _send("classes/comment?where=" + jsonEncode((Comment()..postId = post.id).jsonMap()), null, RequestType.get)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        //2xx
        if (callback != null) {
          List posts = jsonDecode(response.body)["results"];
          callback(posts.map((item) => Comment.withJson(item)).toList(), null);
        }
      } else {
        if (callback != null) {
          callback(null, jsonDecode(response.body));
        }
      }
    });
  }

  void uploadImage(
      String path, Function(String, Map<String, dynamic> error) callback) {
    _upload(File(path)).then((response) {
      response.stream.transform(utf8.decoder).listen((value) {
        if (response.statusCode ~/ 100 == 2) {
          callback(jsonDecode(value)["url"], null);
        } else {
          callback(null, jsonDecode(value));
        }
      });
    });
  }

  void joinPlanet(
      User current, Planet planet, Function(Map<String, dynamic> error) callback) {
    _send("classes/join_planet", {"userId": current.userId, "planetId": planet.id,},
            RequestType.post)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        callback(null);
      } else {
        callback(jsonDecode(response.body));
      }
    });
  }

void planetsJoined(
      User current, Function(List<Planet>,Map<String, dynamic> error) callback) {
        var query  = {"userId": current.userId};
    _send("classes/join_planet?where="+jsonEncode(query), null,
            RequestType.get)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        List items = jsonDecode(response.body)["results"];

        List planetIds = items.map((map)=>map["planetId"]).toList();
        List<Planet> results = [];

        int i = 0;
        for (String item in planetIds) 
        {
          DataSource.center.getPlanet(item, (planet,error){
            i = i+1;
            if(error == null && planet != null){
              results.add(planet);
            }else{
              print("ERROR:"+error.toString());
            }

            if(i == planetIds.length){
              callback(results,null);
            }
          });
        }
        // callback();
      } else {
        callback(null,jsonDecode(response.body));
      }
    });
  }


    void planetUsersCount(Planet planet,Function(int count) callback){
        var query = {"planetId": planet.id};
    _send("classes/join_planet?where=" + jsonEncode(query) + "&count=1", null,
            RequestType.get)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        callback(jsonDecode(response.body)["count"]);
      } else {
        callback(0);
        print("ERROR:"+response.body);
      }
    });
  }

      void planetUsers(Planet planet,Function(List<User>,Map<String, dynamic> error) callback){
        var query = {"planetId": planet.id};
    _send("classes/join_planet?where=" + jsonEncode(query), null,
            RequestType.get)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        List items = jsonDecode(response.body)["results"];

        List userIds = items.map((map)=>map["userId"]).toList();
        List<User> results = [];

        int i = 0;
        for (String item in userIds) 
        {
          this.getUser(item, (user,error){
            i = i+1;
            if(error == null && user != null){
              results.add(user);
            }else{
              print("ERROR:"+error.toString());
            }

            if(i == userIds.length){
              callback(results,null);
            }
          });
        }

        // callback();
      } else {
        callback(null,jsonDecode(response.body));
      }
    });
  }
  
  

  void likePost(
      User current, Post post, Function(Map<String, dynamic> error) callback) {
    _send("classes/post_like", {"userId": current.userId, "postId": post.id,"tId":post.ownerId},
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
    _send(
            "classes/post_like/"+current.userId+"?where=" +
                jsonEncode({"userId": current.userId, "postId": post.id}),
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

  void userLikesCount(User user,Function(int count) callback){
        var query = {"tId": user.userId};
    _send("classes/post_like?where=" + jsonEncode(query) + "&count=1", null,
            RequestType.get)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        callback(jsonDecode(response.body)["count"]);
      } else {
        callback(0);
        print("ERROR:"+response.body);
      }
    });
  }

    void userFansCount(User user,Function(int count) callback){
        var query = {"tId": user.userId};
    _send("classes/user_like?where=" + jsonEncode(query) + "&count=1", null,
            RequestType.get)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        callback(jsonDecode(response.body)["count"]);
      } else {
        callback(0);
        print("ERROR:"+response.body);
      }
    });
  }

  void checkIfLikePost(User current, Post post,
      Function(bool like, Map<String, dynamic> error) callback) {

    var query = {"userId": current.userId, "postId": post.id};
    _send("classes/post_like?where=" + jsonEncode(query) + "&count=1", null,
            RequestType.get)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        callback(jsonDecode(response.body)["count"] > 0, null);
      } else {
        callback(false, jsonDecode(response.body));
      }
    });
  }

  void postCommentsCount(Post post,Function(int) callback){
    var query = (Comment()..postId = post.id).jsonMap();
    _send("classes/comment?where=" + jsonEncode(query) + "&count=1", null,
            RequestType.get)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        callback(jsonDecode(response.body)["count"]);
      } else {
        callback(0);
        print("ERROR:"+response.body);
      }
    });
  }

  void postLikesCount(Post post,Function(int) callback){
    var query = {"postId":post.id};
    _send("classes/post_like?where=" + jsonEncode(query) + "&count=1", null,
            RequestType.get)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        callback(jsonDecode(response.body)["count"]);
      } else {
        callback(0);
        print("ERROR:"+response.body);
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

    var query = {"sId": sid, "tId": tid};

    _send("classes/user_like/"+ current.userId +"?where=" + jsonEncode(query), null,
            RequestType.delete)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        callback(null);
      } else {
        callback(jsonDecode(response.body));
      }
    });
  }

  void checkIfLikeUser(User current, User user,
      Function(bool like, Map<String, dynamic> error) callback) {
    var query = {"sId": current.userId, "tId": user.userId};
    _send("classes/user_like?where=" + jsonEncode(query) + "&count=1", null,
            RequestType.get)
        .then((response) {
      if (response.statusCode ~/ 100 == 2) {
        callback(jsonDecode(response.body)["count"] > 0, null);
      } else {
        callback(false, jsonDecode(response.body));
      }
    });
  }

  // void likePlanet(User current, Planet planet,
  //     Function(Map<String, dynamic> error) callback) {
  //   _send("classes/join_planet",
  //           {"userId": current.userId, "planetId": planet.id}, RequestType.post)
  //       .then((response) {
  //     if (response.statusCode ~/ 100 == 2) {
  //       callback(null);
  //     } else {
  //       callback(jsonDecode(response.body));
  //     }
  //   });
  // }

    void islikePlanet(User current, Planet planet,
      Function(bool,Map<String, dynamic> error) callback) {
        var query = {"userId": current.userId, "planetId": planet.id};

    _send("classes/join_planet?where="+jsonEncode(query)+ "&count=1",null, RequestType.get)
        .then((response) {
          
    if (response.statusCode ~/ 100 == 2) {
            callback(jsonDecode(response.body)["count"] > 0, null);
          } else {
            callback(false, jsonDecode(response.body));
          }
    });
  }

  void dislikePlanet(User current, Planet planet,
      Function(Map<String, dynamic> error) callback) {
    String uid = current.userId;
    String pid = planet.id;
    _send(
            "classes/planet_like/<objectId>?where=" +
                jsonEncode({"userId": uid, "planetId": pid}),
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
    // var uri = Uri.parse("http://pub.dartlang.org/packages/create");
    // var request = new http.MultipartRequest("POST", uri);
    // request.fields['user'] = 'nweiz@google.com';
    // request.files.add(new http.MultipartFile.fromPath(
    //     'package',
    //     'build/package.tar.gz',
    //     contentType: new MediaType('application', 'x-tar'));
    // var response = await request.send();
    // if (response.statusCode == 200) print('Uploaded!');

    // open a bytestream
    var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    // get file length
    var length = await file.length();
    // string to uri
    var uri = Uri.parse(Consts.baseUrl + "files/avartar.png");

    // create multipart request
    var request = http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(file.path));

    // add file to multipart
    request.files.add(multipartFile);
    request.headers["X-LC-Id"] = Consts.appID;
    request.headers["X-LC-Key"] = Consts.appKey;
    request.headers["X-LC-Session"] = PSManager.shared.currentUser.sessionToken;

    // send
    return await request.send();
  }

  Future<http.Response> _send(
      String path, Map<String, dynamic> params, RequestType reqType) async {
    var client = new http.Client();
    String url = Consts.baseUrl + Uri.encodeFull(path);
    // String url = Consts.baseUrl + path;
    print("reqUrl:"+url);
    print("params:"+params.toString());
    http.Response response;

    try {
      Map<String, String> header = {
        "X-LC-Id": Consts.appID,
        "X-LC-Key": Consts.appKey,
        "Content-Type": "application/json"
      };

      if (PSManager.shared.currentUser != null &&
          PSManager.shared.currentUser.sessionToken != null) {
        header["X-LC-Session"] = PSManager.shared.currentUser.sessionToken;
      }

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

    print(response.body);
    return response;
  }
}
