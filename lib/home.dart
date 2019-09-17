import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:formula1/driverdetails.dart';
import 'package:formula1/constructor.dart';
import 'package:formula1/driver.dart';
import 'package:formula1/race.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    RaceWidget(),
    DriverWidget(),
    ConstructorWidget(),
    DriverDetailsWidget()
  ];

  @override
  void initState() async {
    super.initState();
    await DefaultCacheManager().emptyCache();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formula One'),
        backgroundColor: Color.fromRGBO(255, 24, 1, 1),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.red,
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.flagCheckered),
            title: Text('Race'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.racingHelmet),
            title: Text('Driver'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.garage),
            title: Text('Constructor'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.selectCompare),
            title: Text('VS'),
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    }); 
  }
}