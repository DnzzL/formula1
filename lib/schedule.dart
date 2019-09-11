import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'model/race.dart';

class ScheduleWidget extends StatefulWidget {
  @override
  _ScheduleWidgetState createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  List<Race> races = List<Race>();

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
            race.getAttribute("url"),
            race.findElements("RaceName").first.text,
            race.findElements("Date").first.text,
            race.findElements("Time").first.text);
        }).toList();
      });
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return races.length > 0 ?
    Scaffold(
      body: Column(
        children: <Widget>[
          Text("Season ${races.first.season}"),
          Expanded(
            child: ListView.builder(
            itemCount: races.length,
            itemBuilder: (context, index) {
              return Card( //                           <-- Card widget
                child: ListTile(
                  leading: Icon(Icons.fast_forward),
                  title: Text(races.map((e)=> "Round ${e.round}: ${e.name}").toList()[index],
                    style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(races.map((e)=> "${e.date} ${e.time}").toList()[index]),
                ),
              );
            },
          ),
          )
        ],
      )
    ) : Container();
  }
}