import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:planet_social/base/api_service.dart';
import 'package:planet_social/base/manager.dart';
import 'package:planet_social/common/PSAlert.dart';
import 'package:planet_social/common/PSProcess.dart';
import 'package:planet_social/models/planet_model.dart';
import 'package:planet_social/models/post_model.dart';
import 'package:planet_social/route.dart';

class PostPost extends StatefulWidget {
  final Planet planet;

  const PostPost({Key key, this.planet}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PostPostState();
}

class _PostPostState extends State<PostPost> {
  List<String> images = [];

  var controller = TextEditingController();

  _appBar() => AppBar(
          title: Text(
            "发帖",
            style: TextStyle(color: Colors.black, fontSize: 17),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              child: Image.asset(
                "assets/back.png",
              ),
              padding: EdgeInsets.all(11),
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: _post,
              child: Text(
                "发布",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            )
          ]);

  _imagePreview() {
    double l = (MediaQuery.of(context).size.width - 50) / 4;
    return Container(
        padding: EdgeInsets.all(10),
        height: l + 20,
        color: Color(0xFFF5F5F9),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 1 + images.length >= 6 ? 6 : images.length + 1,
          // itemExtent: 10,
          itemBuilder: (_, index) {
            if (images.length >= 6) {
              return GestureDetector(
                child: ClipRRect(
                    child: Image.file(
                      File(images[index]),
                      height: l,
                      width: l,
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    )),
                onTap: () {
                  _confirmDelete(index);
                },
              );
            } else {
              if (index == 0) {
                return GestureDetector(
                  child: Image.asset(
                    "assets/ad_ph.png",
                    height: l,
                    width: l,
                  ),
                  onTap: _pickImages,
                );
              } else {
                return GestureDetector(
                  child: ClipRRect(
                      child: Image.file(
                        File(images[index - 1]),
                        height: l,
                        width: l,
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      )),
                  onTap: () {
                    _confirmDelete(index - 1);
                  },
                );
              }
            }
          },
          separatorBuilder: (_, index) =>
              Padding(padding: EdgeInsets.only(left: 10)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _imagePreview(),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: controller,
                  maxLines: 15,
                  maxLength: 1000,
                  decoration: InputDecoration(
                      hintText: "写点什么...", border: InputBorder.none),
                ),
              )
            ],
          ),
        ));
  }

  _confirmDelete(int index) {
    PSAlert.showConfirm(context, "确认删除此图片？", () {
      setState(() {
        images.removeAt(index);
      });
    });
  }

  _pickImages() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        setState(() {
          images.insert(0, value.path);
        });
      }
    });
  }

  _post() {
    PSProcess.show(context);
    var post = Post();
    post.ownerId = PSManager.shared.currentUser.userId;
    post.content = controller.text;
    post.starId = widget.planet.id;
    post.starTitle = widget.planet.title;
    _uploadImages((paths, error) {
      if (error == null) {
        post.images = paths;

        ApiService.shared.createPost(post, (_, error) {
          PSProcess.dismiss(context);
          if (error == null) {
            PSAlert.show(context, "成功", "帖子发布成功", confirm: () {
              PSRoute.pop(context);
            });
          } else {
            PSAlert.show(context, "发布失败", error.toString());
          }
        });
      } else {
        PSProcess.dismiss(context);
        PSAlert.show(context, "图片上传失败", error.toString());
      }
    });
  }

  _uploadImages(
      Function(List<String> paths, Map<String, dynamic> error) callback) {
    List<String> paths = [];
    int i = images.length - 1;

    if(i<0){
      callback(paths, null);
      return;
    }

    _up() {
      ApiService.shared.uploadImage(images[i], (url, error) {
        if (url != null) {
          paths.add(url);
          i = i - 1;
          if (i < 0) {
            callback(paths, null);
          } else {
            _up();
          }
        } else {
          callback(null, error);
        }
      });
    }

    _up();
  }
}
