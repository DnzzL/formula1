import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'model/race.dart';
import 'racerow.dart';

class RaceWidget extends StatefulWidget {
  @override
  _RaceWidgetState createState() => _RaceWidgetState();
}

class _RaceWidgetState extends State<RaceWidget> {
  List<Race> races = List<Race>();
  int nextRace;
  ScrollController _scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    fetch();
  }

  void fetch() async {
    String api = "https://ergast.com/api/f1";
    String url = "$api/current";
    
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var xmlResponse = xml.parse(response.body);
      setState(() {
      races = xmlResponse.findAllElements('Race')
        .map<Race>((race) {
            return Race(
            race.getAttribute("season"),
            race.getAttribute("round"),
            race.findElements("Circuit").first.getAttribute("circuitId"),
            race.findElements("RaceName").first.text,
            race.findElements("Date").first.text,
            race.findElements("Time").first.text,
            race.findElements("Circuit").first.findElements("Location").first.getAttribute("lat"),
            race.findElements("Circuit").first.findElements("Location").first.getAttribute("long"),
            race.findElements("Circuit").first.findElements("Location").first.findElements("Locality").first.text,
            race.findElements("Circuit").first.findElements("Location").first.findElements("Country").first.text
            );
        }).toList();
        nextRace = int.parse(races.firstWhere((race) =>
          DateTime.parse(race.date).isAfter(DateTime.now())
        ).round) - 1;
      });
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return races.length > 0 ?
    Container(
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
                    (context, index) =>  RaceRow(races[index], index==nextRace),
                    childCount: races.length,
                ),
              ),
            ),
          ],
        ),
      ),
    ) : Container();
  }
}