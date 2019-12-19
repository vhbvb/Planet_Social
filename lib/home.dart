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

  Widget _currentPage() {
    switch (_selectedIndex) {
      case 0:
        return PSRoute.explore;
      case 1:
        return PSRoute.myPlanet;
      case 2:
        return PSRoute.message;
      case 3:
        return PSRoute.me;
      default:
        return null;
    }
  }

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
    super.initState();
    PSManager.shared.isLogin.then((islogin) {
      if (!islogin) {
        Future.delayed(Duration(seconds: 1), () {
          PSRoute.push(context, "login", null);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _currentPage(),
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
