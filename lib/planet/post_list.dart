import 'package:flutter/material.dart';
import 'package:planet_social/common/post_detail.dart';
import 'package:planet_social/models/post_model.dart';

class PostList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PostListState();
}

class _PostListState extends State<PostList>
    with SingleTickerProviderStateMixin {
  TabController _tapController;

  _tabbar() => Padding(
        padding: EdgeInsets.only(
            top: 30, right: MediaQuery.of(context).size.width / 2),
        child: TabBar(
          controller: _tapController,
          indicatorPadding: EdgeInsets.only(right: 30, left: 30),
          indicatorWeight: 3,
          indicatorColor: Color.fromARGB(255, 255, 130, 130),
          tabs: <Widget>[
            Padding(
              child: Text("最新帖子",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              padding: EdgeInsets.only(bottom: 5),
            ),
            Padding(
              child: Text("热门贴子",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              padding: EdgeInsets.only(bottom: 5),
            )
          ],
        ),
      );

  _postsTabView() => Expanded(
        child: TabBarView(
          controller: _tapController,
          children: <Widget>[
            ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => PostDetail(
                post: Post(),
              ),
            ),
            ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => PostDetail(
                post: Post(),
              ),
            ),
          ],
        ),
      );

  @override
  void initState() {
    _tapController = TabController(vsync: this, length: 2)
      ..addListener(() {
        // _tapController.indexIsChanging
        // print(_tapController.offset);
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[_tabbar(), _postsTabView()],
    ));
  }
}
