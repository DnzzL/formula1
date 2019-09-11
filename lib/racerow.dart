import 'package:flutter/material.dart';
import 'model/race.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RaceRow extends StatelessWidget {

  final Race race;

  RaceRow(this.race);

  @override
  Widget build(BuildContext context) {
    
    final raceThumbnail = Container(
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
            image: new AssetImage("assets/img/races/${race.circuitId}.png"),
            height: 90,
            width: 90,
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
      fontSize: 20.0,
      fontWeight: FontWeight.w600
    );

    Widget _raceValue({String value, IconData icon}) {
      return new Row(
        children: <Widget>[
          Icon(icon, size: 18.0, color: Colors.white,),
          new Container(width: 8.0),
          new Text(value, style: regularTextStyle),
        ]
      );
    }


    final raceCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(130.0, 16.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 2.0),
          new Text(race.name, style: headerTextStyle),
          new Container(height: 4.0),
          new Text("${race.date} ${race.time}", style: subHeaderTextStyle),
          new Container(
            margin: new EdgeInsets.symmetric(vertical: 4.0),
            height: 2.0,
            width: 18.0,
            color: Colors.red
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                child: _raceValue(
                  value: race.locality,
                  icon: MdiIcons.city)

              ),
              new Expanded(
                child: _raceValue(
                  value: race.country,
                  icon: MdiIcons.flagTriangle)
              )
            ],
          ),
        ],
      ),
    );


    final raceCard = new Container(
      child: raceCardContent,
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
      height: 120.0,
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 20.0,
      ),
      child: new Stack(
        children: <Widget>[
          raceCard,
          raceThumbnail,
        ],
      )
    );
  }
}