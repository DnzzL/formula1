import 'package:flutter/material.dart';
import 'package:formula1/standingrow.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

class DriverStanding {
  String position;
  String points;
  String wins;
  String name;
  String dateOfBirth;
  String nationality;
  String constructor;
  String driverId;

  DriverStanding(String position, String points, String wins, String name, String dateOfBirth, String nationality, String constructor, String driverId) {
    this.position = position;
    this.points = points;
    this.wins = wins;
    this.name = name;
    this.dateOfBirth = dateOfBirth;
    this.nationality = nationality;
    this.constructor = constructor;
    this.driverId = driverId;
  }
}

class DriverWidget extends StatefulWidget {
  @override
  _DriverWidgetState createState() => _DriverWidgetState();
}

class _DriverWidgetState extends State<DriverWidget> {
  List<DriverStanding> standings = List<DriverStanding>();

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    fetch();
  }


  void fetch() async {
    String api = "https://ergast.com/api/f1";
    String url = "$api/current/driverStandings";
    
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var xmlResponse = xml.parse(response.body);
      setState(() {
      standings =  xmlResponse.findAllElements("DriverStanding").map((standing) {
        return DriverStanding(standing.getAttribute("position"),
         standing.getAttribute("points"),
          standing.getAttribute("wins"),
           '${standing.findElements("Driver").first.findElements("GivenName").first.text} ${standing.findElements("Driver").first.findElements("FamilyName").first.text}',
            standing.findElements("Driver").first.findElements("DateOfBirth").first.text,
             standing.findElements("Driver").first.findElements("Nationality").first.text,
              standing.findElements("Constructor").first.findElements("Name").first.text,
              standing.findElements("Driver").first.getAttribute("driverId"));
      }).toList();
      });
      
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        color: Colors.black87,
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          shrinkWrap: false,
          slivers: <Widget>[
           SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              sliver:  SliverList(
                delegate:  SliverChildBuilderDelegate(
                    (context, index) =>  DriverStandingRow(standings[index]),
                  childCount: standings.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}