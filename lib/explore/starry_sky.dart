import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:planet_social/explore/star_style.dart';

class StarrySky extends StatefulWidget {
  const StarrySky({Key key, this.onScroll, this.stars}) : super(key: key);
  final Function(Offset) onScroll;
  final List stars;
  @override
  State<StatefulWidget> createState() => _StarrySkyState();
}

class _StarrySkyState extends State<StarrySky> with SingleTickerProviderStateMixin{

  Offset _offset = Offset(0, 0);
  Offset _cachedOffset = Offset(0, 0);
  List _gridViews;
  AnimationController _controller;
  Animation<Offset> _animation;
  final int _animationTime = 1000;

  double get cw => MediaQuery.of(context).size.width;
  double get ch => MediaQuery.of(context).size.height;

  _background() => GestureDetector(
      onPanStart: (start) {
      },
      onPanCancel: () {},
      onPanEnd: (end) {
        double x= end.velocity.pixelsPerSecond.dx;
        double y= end.velocity.pixelsPerSecond.dy;
        if(x == 0 && y == 0) return;

        _controller.reset();
        Animation curve = CurvedAnimation(parent: _controller,curve: Curves.easeOut);
        _animation = Tween(begin: Offset(x,y),end: Offset(0, 0)).animate(curve)..addListener((){
          _needScroll(Offset(_animation.value.dx * 0.001,_animation.value.dy * 0.001));
        });
        _controller.forward();
      },
      onPanUpdate: (detail) {
        _needScroll(detail.delta);
      },
      child: OverflowBox(
        alignment: Alignment.center,
        maxHeight: ch *3,
        maxWidth: cw *3,
        child: Stack(
          children: _grids(),
        ),
      ));

  _needScroll(Offset offset){
        double x = _offset.dx + offset.dx;
        double y = _offset.dy + offset.dy;
        _offset = Offset(x, y);

        double cx = _cachedOffset.dx + offset.dx;
        double cy = _cachedOffset.dy + offset.dy;

        if (cx < 0) {
          _updateGrids(3);
          cx = cx + cw;
        }
        if (cx > cw) {
          _updateGrids(1);
          cx = cx - cw;
        }
        if (cy < 0) {
          _updateGrids(2);
          cy = cy + ch;
        }
        if (cy > ch) {
          _updateGrids(0);
          cy = cy - ch;
        }
        setState(() {
          _cachedOffset = Offset(cx, cy);
          widget.onScroll(_offset);
        });
  }

  List<Widget> _grids() {
    _updateGrids(4);

    List<Widget> grids = [];
    //第几行
    for (var i = 0; i < 2; i++) {
      //第几列
      for (var j = 0; j < 2; j++) {
        
        grids.add(Positioned(
          top: i * ch+ _cachedOffset.dy,
          left: j * cw + _cachedOffset.dx,
          child: _gridViews[i][j],
        ));
      }
    }

    for (var item in widget.stars) 
    {
      Offset position = item.position;
      Offset distance = Offset(position.dx + _offset.dx,position.dy + _offset.dy);
      double padding = 100;
      bool left = distance.dx > -(cw/2+padding);
      bool right = distance.dx < (cw/2+padding);
      bool top = distance.dy > -(ch/2+padding);
      bool bottom = distance.dy < (ch/2+padding);

      if ( left && right && top && bottom ){
        grids.add(StarStyle(
          model: item,
          left: distance.dx+3/2*cw,
          top: distance.dy+3/2*ch,
        ));
      }
    }
    
    return grids;
  }

//0 top、1 left、2 bottom、3 right
  _updateGrids(int type) {
    Widget back = SizedBox(child: Image.asset("assets/star/star.jpeg",fit: BoxFit.fill,),height: ch,width: cw,);

    if (_gridViews == null) {
      _gridViews = [[back, back], 
                    [back, back]];
    } else {
      switch (type) {
        case 0:
          _gridViews.removeLast();
          _gridViews.insert(0, [back,back]);
          break;
        case 1:
          _gridViews[0].removeLast();
          _gridViews[0]..insert(0, back);
          _gridViews[1].removeLast();
          _gridViews[1]..insert(0, back);
          break;
        case 2:
          _gridViews.removeAt(0);
          _gridViews.add([back,back]);
          break;
        case 3:
          _gridViews[0].removeAt(0);
          _gridViews[0]..insert(0, back);
          _gridViews[1].removeAt(0);
          _gridViews[1]..insert(0, back);
          break;
        default:
      }
    }
  }

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(milliseconds: _animationTime),vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _background();
  }
}
