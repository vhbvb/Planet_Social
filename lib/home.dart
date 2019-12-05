import 'package:flutter/material.dart';
import 'package:planet_social/base/bar_item.dart';
import 'package:planet_social/explore/explore.dart';
import 'package:planet_social/message/message.dart';
import 'package:planet_social/mine/user_detail.dart';
import 'package:planet_social/planet/my_planet.dart';

class PlanetSocial extends StatefulWidget {
  @override
  _PlanetSocialState createState() => _PlanetSocialState();
}

class _PlanetSocialState extends State<PlanetSocial> {

  int _selectedIndex = 0;

  Widget _currentPage(){
    switch (_selectedIndex) {
      case 0: return Explore();
      case 1: return MyPlanet();
      case 2: return Message();
      case 3: return UserDetail();
      default: return null;
    }
  }

  List<BottomNavigationBarItem> _createItems(){
    
    return BarItems.items().map((item){
      return BottomNavigationBarItem(
        title: Text(
          item.title,
          style: TextStyle(
            color: (item.index == _selectedIndex ? Colors.red : Colors.black),
            fontSize: 14.0
           ),
        ),
        icon: Image.asset(item.defaultImage, height: 27.0, width: 27.0),
        activeIcon: Image.asset(item.selectedImage, height: 27.0, width: 27.0)
      );
    }).toList();
  }
  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(BarItems.items()[_selectedIndex].title),
      // ),
    
      body: _currentPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: _createItems(),
        currentIndex: _selectedIndex,
        onTap: (int index){
          setState(() {
            print(index);
            _selectedIndex = index;
          });
        },
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
