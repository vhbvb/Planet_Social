import 'package:flutter/material.dart';
import 'package:planet_social/base/bar_item.dart';
import 'package:planet_social/base/manager.dart';
import 'package:planet_social/route.dart';

class PlanetSocial extends StatefulWidget {
  @override
  _PlanetSocialState createState() => _PlanetSocialState();
}

class _PlanetSocialState extends State<PlanetSocial> {
  int _selectedIndex = 0;

  List<BottomNavigationBarItem> _createItems() {
    return BarItems.items().map((item) {
      return BottomNavigationBarItem(
          title: Text(
            item.title,
            style: TextStyle(
                color:
                    (item.index == _selectedIndex ? Colors.red : Colors.black),
                fontSize: 14.0),
          ),
          icon: Image.asset(item.defaultImage, height: 27.0, width: 27.0),
          activeIcon:
              Image.asset(item.selectedImage, height: 27.0, width: 27.0));
    }).toList();
  }

  @override
  void initState() {

    PSManager.shared.mainContext = context;
    PSManager.shared.login();
    PSManager.shared.registThirdParty();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          
          children: <Widget>[
            PSRoute.explore,
            PSRoute.myPlanet,
            PSRoute.message,
            PSRoute.me
          ],
          index: _selectedIndex,
        ),

        // body: <Widget>[
        //     PSRoute.explore,
        //     PSRoute.myPlanet,
        //     PSRoute.message,
        //     PSRoute.me
        //   ][_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: _createItems(),
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            setState(() {
              print(index);
              _selectedIndex = index;
            });
          },
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
