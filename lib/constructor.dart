import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:formula1/model/constructorstanding.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

import 'constructorstandingrow.dart';

class ConstructorWidget extends StatefulWidget{
  @override
  _ConstructorWidgetState createState() => _ConstructorWidgetState();
}

class _ConstructorWidgetState extends State<ConstructorWidget> {
  List<ConstructorStanding> constructorStandings = List<ConstructorStanding>();

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    fetch();
  }


  void fetch() async {
    String api = "https://ergast.com/api/f1";
    String url = "$api/current/constructorStandings";
    
    var response = await DefaultCacheManager().getSingleFile(url);
      var xmlResponse = xml.parse(response.readAsStringSync());
      setState(() {
        constructorStandings =  xmlResponse.findAllElements("ConstructorStanding").map((standing) {
          return ConstructorStanding(
            standing.getAttribute("position"),
            standing.getAttribute("points"),
            standing.getAttribute("wins"),
            standing.findElements("Constructor").first.getAttribute("constructorId"),
            standing.findElements("Constructor").first.findElements("Name").first.text,
            standing.findElements("Constructor").first.findElements("Nationality").first.text);
        }).toList();
      });
}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        color: Colors.grey[900],
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          shrinkWrap: false,
          slivers: <Widget>[
           SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              sliver:  SliverList(
                delegate:  SliverChildBuilderDelegate(
                    (context, index) =>  ConstructorStandingRow(constructorStandings[index]),
                    childCount: constructorStandings.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}