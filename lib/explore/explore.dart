import 'package:flutter/material.dart';
import 'package:planet_social/explore/starry_sky.dart';
import 'package:planet_social/explore/statistics.dart';
import 'package:planet_social/models/planet_model.dart';
import 'package:planet_social/models/user_model.dart';

class Explore extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ExploreState();
}

class _ExploreState extends State<Explore>{
  @override

  List _elements = [Planet(),User(),Planet(),User(),Planet(),User(),Planet(),User(),Planet(),User(),Planet(),User(),Planet(),User(),Planet(),User(),Planet(),User(),Planet(),User(),Planet(),User(),];

  _header() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 58,bottom: 13),
        child: Text("探索",style: TextStyle(fontSize: 17,color: Colors.white),)
      ),
      Statistics(users: 12312,planets: 12344,)
    ],
  );


  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        StarrySky(onScroll: (offset){
          // _stars.
        },
        stars: _elements),
        _header(),
      ],
    );
  }
}


// class _StarsOverFlowBox extends StatefulWidget {
//   List stars;
//   Offset offset = Offset(0,0);
//   @override
//   State<StatefulWidget> createState() => _StarsOverFlowBoxState();
// }

// class _StarsOverFlowBoxState extends State<_StarsOverFlowBox>{
//   @override
//   Widget build(BuildContext context) {
//     return OverflowBox(
//       alignment: Alignment.topLeft,
//       maxHeight: MediaQuery.of(context).size.height + 100,
//       maxWidth: MediaQuery.of(context).size.width + 100,
//       child: Stack(

//       ),
//     );
//   }
// }