import 'package:flutter/material.dart';
import 'package:formula1/driver.dart';

import 'driver.dart';

class DriverStandingRow extends StatelessWidget {

  final DriverStanding driverStanding;

  DriverStandingRow(this.driverStanding);

  @override
  Widget build(BuildContext context) {
    
    final driverStandingThumbnail = Container(
      margin: new EdgeInsets.symmetric(
        vertical: 8.0
      ),
      alignment: FractionalOffset.centerLeft,
      child: Stack(
      children: <Widget>[
        ClipRRect(
        borderRadius: new BorderRadius.circular(90.0),
        child: Image(
            image: new AssetImage("assets/img/drivers/${driverStanding.driverId}.jpg"),
            height: 92.0,
            width: 92.0,
          )
        )
      ],
    ),
    );


    final baseTextStyle = const TextStyle(
      fontFamily: 'Poppins'
    );
    final regularTextStyle = baseTextStyle.copyWith(
      color: Colors.white70,
      fontSize:11.0,
      fontWeight: FontWeight.w400
    );
    final subHeaderTextStyle = regularTextStyle.copyWith(
      fontSize: 14.0
    );
    final headerTextStyle = baseTextStyle.copyWith(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.w600
    );

    Widget _driverStandingValue({String value, IconData icon}) {
      return new Row(
        children: <Widget>[
          Icon(icon, size: 12.0, color: Colors.white,),
          new Container(width: 8.0),
          new Text(value, style: regularTextStyle),
        ]
      );
    }


    final driverStandingCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 2.0),
          new Text(driverStanding.name, style: headerTextStyle),
          new Container(height: 4.0),
          new Text(driverStanding.constructor, style: subHeaderTextStyle),
          new Container(
            margin: new EdgeInsets.symmetric(vertical: 4.0),
            height: 2.0,
            width: 18.0,
            color: Colors.red
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                child: _driverStandingValue(
                  value: driverStanding.points,
                  icon: Icons.confirmation_number)

              ),
              new Expanded(
                child: _driverStandingValue(
                  value: driverStanding.wins,
                  icon: Icons.first_page)
              )
            ],
          ),
        ],
      ),
    );


    final driverStandingCard = new Container(
      child: driverStandingCardContent,
      height: 124.0,
      margin: new EdgeInsets.only(left: 46.0),
      decoration: new BoxDecoration(
        color: Colors.black,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: new Offset(0.0, 5.0),
          ),
        ],
      ),
    );


    return new Container(
      height: 100.0,
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 20.0,
      ),
      child: new Stack(
        children: <Widget>[
          driverStandingCard,
          driverStandingThumbnail,
        ],
      )
    );
  }
}