import 'package:flutter/material.dart';
import 'model/constructorstanding.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ConstructorStandingRow extends StatelessWidget {

  final ConstructorStanding constructorStanding;

  ConstructorStandingRow(this.constructorStanding);

  @override
  Widget build(BuildContext context) {
    
    final constructorStandingThumbnail = Container(
      margin: new EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 15
      ),
      alignment: FractionalOffset.centerLeft,
      child: Stack(
      children: <Widget>[
        ClipRRect(
        borderRadius: new BorderRadius.circular(90.0),
        child: Image(
            image: new AssetImage("assets/img/constructors/${constructorStanding.constructorId}.png"),
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
      fontSize:12.0,
      fontWeight: FontWeight.w400
    );
    final subHeaderTextStyle = regularTextStyle.copyWith(
      fontSize: 16.0
    );
    final headerTextStyle = baseTextStyle.copyWith(
      color: Colors.white,
      fontSize: 24.0,
      fontWeight: FontWeight.w600
    );

    Widget _constructorStandingValue({String value, IconData icon}) {
      return new Row(
        children: <Widget>[
          Icon(icon, size: 18.0, color: Colors.white,),
          new Container(width: 8.0),
          new Text(value, style: regularTextStyle),
        ]
      );
    }


    final constructorStandingCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(130.0, 10.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 2.0),
          new Text(constructorStanding.name, style: headerTextStyle),
          new Container(height: 4.0),
          new Text(constructorStanding.nationality, style: subHeaderTextStyle),
          new Container(
            margin: new EdgeInsets.symmetric(vertical: 4.0),
            height: 2.0,
            width: 18.0,
            color: Colors.red
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                child: _constructorStandingValue(
                  value: constructorStanding.points,
                  icon: MdiIcons.counter)

              ),
              new Expanded(
                child: _constructorStandingValue(
                  value: constructorStanding.wins,
                  icon: MdiIcons.medal)
              )
            ],
          ),
        ],
      ),
    );


    final constructorStandingCard = new Container(
      child: constructorStandingCardContent,
      height: 124.0,
      decoration: new BoxDecoration(
        color: Colors.grey[850],
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.grey[900],
            blurRadius: 10.0,
            offset: new Offset(0.0, 5.0),
          ),
        ],
      ),
    );


    return new Container(
      height: 110.0,
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 20.0,
      ),
      child: new Stack(
        children: <Widget>[
          constructorStandingCard,
          constructorStandingThumbnail,
        ],
      )
    );
  }
}