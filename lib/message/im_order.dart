import 'package:flutter/material.dart';

class FTIMChatOrder {
  Function onAnimation;
  AnimationController controller;
  Animation animation;
  @override
  FTIMChatOrder({this.controller, this.onAnimation}) {
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animation.addListener(onAnimation);
  }

  // Function animation;
  bool unfold = false;

  int stars = 3;
  int numbers = 9;
  String region = "微信";
  String level = "钻石";
  int price = 30;
  String honour = "国服最强";
  int step = 0;

  Widget _createStars() {
    List<Padding> _createChilds() {
      List childs = <Padding>[];

      for (int i = 0; i < stars; i++) {
        childs.add(new Padding(
            padding: EdgeInsets.only(right: 3.0),
            child: new Image.asset("assets/im_star_1.png",
                height: 10.0, width: 10.0)));
      }

      for (int i = 0; i < 5 - stars; i++) {
        childs.add(new Padding(
            padding: EdgeInsets.only(right: 3.0),
            child: new Image.asset("assets/im_star_0.png",
                height: 10.0, width: 10.0)));
      }

      childs.add(new Padding(
          padding: EdgeInsets.only(left: 6.0),
          child: new Text("累计" + numbers.toString() + "单",
              style: TextStyle(fontSize: 12.0, color: Colors.white))));

      return childs;
    }

    return new Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: new Row(
        children: _createChilds(),
      ),
    );
  }

  Widget _createOperation() {
    if (step == 0) {
      return new Row(
          // crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: new GestureDetector(
                  onTap: () {},
                  child: new Container(
                    height: 28.0,
                    width: 50.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey[300]),
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    ),
                    child: new Text("拒绝",
                        style:
                            TextStyle(fontSize: 12.0, color: Colors.grey[300])),
                  )),
            ),
            new ClipPath(
              clipper: _ButtonClipper(reverse: true),
              clipBehavior: Clip.antiAlias,
              child: new Container(
                alignment: Alignment.center,
                color: Colors.red,
                width: 90.0,
                height: 28.0,
                child: new Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: new Text("接单",
                      style: TextStyle(fontSize: 14.0, color: Colors.white)),
                ),
              ),
            )
          ]);
    } else {
      return new ClipPath(
        clipper: _ButtonClipper(reverse: true),
        clipBehavior: Clip.antiAlias,
        child: new Container(
          alignment: Alignment.center,
          color: Colors.red,
          width: 105.0,
          height: 28.0,
          child: new Text("取消订单",
              style: TextStyle(fontSize: 14.0, color: Colors.white)),
        ),
      );
    }
  }

  Widget createFold(BuildContext context) {
    return new Padding(
        padding: EdgeInsets.only(
            top: 44.0 + 15.0 + MediaQuery.of(context).padding.top),
        child: new ClipPath(
            clipper: _ButtonClipper(reverse: false),
            clipBehavior: Clip.antiAlias,
            child: new GestureDetector(
                onTap: () {
                  controller.forward();
                },
                child: new Container(
                    color: Color.fromARGB(255, 36, 38, 50),
                    height: 36.0,
                    width: 100.0,
                    child: new Row(
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: new Text("等待接单",
                              style: new TextStyle(
                                  fontSize: 12.0, color: Color(0xede0e3ff))),
                        ),
                        new Image.asset("assets/im_row.png")
                      ],
                    )))));
  }

  Widget createUnfold(BuildContext context) {
    return new Transform.scale(
      origin: Offset(0.0, 44.0 + MediaQuery.of(context).padding.top + 18.0),
      alignment: Alignment.topLeft,
      scale: animation.value,
      child: new Padding(
          padding:
              EdgeInsets.only(top: 44.0 + MediaQuery.of(context).padding.top),
          child: new Column(
            children: <Widget>[
              new Container(
                color: Color.fromARGB(255, 36, 38, 50),
                height: 150.0,
                width: MediaQuery.of(context).size.width,
                child: new Column(children: <Widget>[
                  new Container(
                    height: 92.0,
                    width: MediaQuery.of(context).size.width,
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.only(
                              top: 15.0, left: 15.0, right: 9.0),
                          child: new ClipOval(
                              child: Image.network(
                            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1573560951288&di=ed3b4995035253955cef2cce4161f442&imgtype=0&src=http%3A%2F%2Fi2.letvimg.com%2Fvrs%2F201409%2F03%2Ffda8fc43-c8ad-4358-ab30-e49327b5d8f8.jpg",
                            height: 46.0,
                            width: 46.0,
                          )),
                        ),
                        new Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    new Text("Ankyo",
                                        style: TextStyle(
                                            color: Color(0xede0d3ff),
                                            fontSize: 14.0)),
                                    new Padding(
                                        padding: EdgeInsets.only(left: 9.0),
                                        child: new Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 0.5,
                                                  color: Color.fromARGB(
                                                      255, 218, 181, 144),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(2.0)),
                                            child: new Padding(
                                                padding: EdgeInsets.only(
                                                    left: 2.5, right: 2.5),
                                                child: new Text(
                                                  honour,
                                                  style: TextStyle(
                                                    fontSize: 9.0,
                                                    color: Color.fromARGB(
                                                        255, 218, 181, 144),
                                                  ),
                                                ))))
                                  ],
                                ),
                                _createStars(),
                                new Text(
                                  "订单：" +
                                      region +
                                      " " +
                                      level +
                                      " " +
                                      price.toString() +
                                      "元/局",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12.0),
                                )
                              ],
                            )),
                        new Expanded(
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Padding(
                                    padding:
                                        EdgeInsets.only(top: 9.0, right: 5.0),
                                    child: new GestureDetector(
                                      onTap: () {
                                        controller.reverse();
                                      },
                                      child: new Image.asset(
                                          "assets/im_row.png",
                                          height: 36.0,
                                          width: 36.0),
                                    )),
                                new Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: _createOperation(),
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                  new Padding(
                    child: new Divider(
                      color: Colors.white.withAlpha(50),
                      height: 1.0,
                    ),
                    padding: EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 0.0),
                  ),
                  new Expanded(
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Expanded(
                            child: new Text("待接单",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: step != 0
                                        ? Colors.white
                                        : Color.fromARGB(255, 218, 181, 144)),
                                textAlign: TextAlign.center)),
                        new Expanded(
                            child: new Text("已接单",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: step != 1
                                        ? Colors.white
                                        : Color.fromARGB(255, 218, 181, 144)),
                                textAlign: TextAlign.center)),
                        new Expanded(
                            child: new Text("进行中",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: step != 2
                                        ? Colors.white
                                        : Color.fromARGB(255, 218, 181, 144)),
                                textAlign: TextAlign.center)),
                        new Expanded(
                            child: new Text("待评价",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: step != 3
                                        ? Colors.white
                                        : Color.fromARGB(255, 218, 181, 144)),
                                textAlign: TextAlign.center)),
                      ],
                    ),
                  ),
                ]),
              ),

              Stack(
                    children: <Widget>[
                      new Container(
                        // color: Color.fromARGB(255, 218, 181, 144),
                        height: 3.0,
                        // color: Colors.green.withAlpha(150),
                        // width: (MediaQuery.of(context).size.width - 30.0) *
                        //     (0.25 / 2.0 + 0.25 * step),
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left:0.0),
                        child: new Stack(
                          children: <Widget>[

                            new Container(
                              color: Color.fromARGB(255, 218, 181, 144),
                              width: MediaQuery.of(context).size.width /8.0 * (1 + 2*step),
                            ),

                            new Padding(
                              padding: EdgeInsets.only(left:MediaQuery.of(context).size.width/8.0 - 17.5,right:MediaQuery.of(context).size.width/8.0 - 17.5),
                              child:new Slider(
                                value: 1.0/3 * step,
                                // value: 1.0,
                                onChanged: (double value) {},
                                activeColor: Color.fromARGB(255, 218, 181, 144),
                                inactiveColor:
                                    Color.fromARGB(255, 218, 181, 144).withAlpha(0),
                              ),
                            )

                          ],
                        )
                      ),
                      
                    ],
                  )
            ],
          )),
    );
  }
}

class _ButtonClipper extends CustomClipper<Path> {
  _ButtonClipper({this.reverse}) : super();

  final bool reverse;

  @override
  Path getClip(Size size) {
    // This is where we decide what part of our image is going to be
    // visible. If you try to run the app now, nothing will be shown.
    var path = Path();
    // Draw a straight line from current point to the bottom left corner.
    // path.lineTo(0.0, size.height);

    // Draw a straight line from current point to the top right corner.
    // path.lineTo(size.width, 0.0);

    // path.lineTo(0.0, size.height - 20);

    if (reverse) {
      path.moveTo(size.width, size.height);
      path.lineTo(size.height / 2.0, size.height);

      // var firstControlPoint = Offset(size.width + 10.0, size.height/2.0);
      // var firstEndPoint = Offset(size.width - size.height/2.0, size.height);
      // path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
      //     firstEndPoint.dx, firstEndPoint.dy);

      // path.arcTo(rect, startAngle, sweepAngle, forceMoveTo)
      path.arcToPoint(Offset(size.height / 2.0, 0.0),
          radius: Radius.circular(size.height / 2.0));

      path.lineTo(size.width, 0.0);

      path.close();
    } else {
      path.lineTo(size.width - size.height / 2.0, 0.0);

      // var firstControlPoint = Offset(size.width + 10.0, size.height/2.0);
      // var firstEndPoint = Offset(size.width - size.height/2.0, size.height);
      // path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
      //     firstEndPoint.dx, firstEndPoint.dy);

      // path.arcTo(rect, startAngle, sweepAngle, forceMoveTo)
      path.arcToPoint(Offset(size.width - size.height / 2.0, size.height),
          radius: Radius.circular(size.height / 2.0));

      path.lineTo(0.0, size.height);

      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
