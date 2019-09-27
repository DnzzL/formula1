import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:formula1/model/driverstanding.dart';
import 'package:formula1/model/qualifyingresults.dart';
import 'package:formula1/model/raceresults.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DriverDetailsWidget extends StatefulWidget {
  final DriverStanding driverStanding;
  const DriverDetailsWidget({Key key, this.driverStanding}) : super(key: key);
  @override
  _DriverDetailsWidgetState createState() =>
      _DriverDetailsWidgetState(this.driverStanding);
}

class _DriverDetailsWidgetState extends State<DriverDetailsWidget> {
  final DriverStanding driverStanding;
  _DriverDetailsWidgetState(this.driverStanding);

  List<QualifyingResult> qualifyingResults = List<QualifyingResult>();
  List<RaceResult> raceResults = List<RaceResult>();

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    _fetchQualifyingResults();
    _fetchRaceResults();
  }

  static final baseTextStyle = const TextStyle(fontFamily: 'Poppins');
  static final regularTextStyle = baseTextStyle.copyWith(
      color: Colors.white70, fontSize: 12.0, fontWeight: FontWeight.w400);
  final subHeaderTextStyle = regularTextStyle.copyWith(fontSize: 16.0);
  final headerTextStyle = baseTextStyle.copyWith(
      color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.w600);

  void _fetchQualifyingResults() async {
    String api = "https://ergast.com/api/f1";
    String url =
        "$api/current/drivers/${this.driverStanding.driverId}/qualifying";

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var xmlResponse = xml.parse(response.body);
      print(xmlResponse.findElements("QualifyingResult"));
      setState(() {
        qualifyingResults = xmlResponse.findAllElements("Race").map((race) {
          return QualifyingResult(
              race.getAttribute("season"),
              race.getAttribute("round"),
              race.findElements("Circuit").first.getAttribute("circuitId"),
              race
                  .findElements("QualifyingList")
                  .first
                  .findElements("QualifyingResult")
                  .first
                  .getAttribute("position"),
              race
                  .findElements("QualifyingList")
                  .first
                  .findElements("QualifyingResult")
                  .first
                  .findElements("Driver")
                  .first
                  .getAttribute("driverId"));
        }).toList();
      });
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
  }

  void _fetchRaceResults() async {
    String api = "https://ergast.com/api/f1";
    String url = "$api/current/drivers/${this.driverStanding.driverId}/results";

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var xmlResponse = xml.parse(response.body);
      print(xmlResponse.findElements("QualifyingResult"));
      setState(() {
        raceResults = xmlResponse.findAllElements("Race").map((race) {
          return RaceResult(
              race.getAttribute("season"),
              race.getAttribute("round"),
              race.findElements("Circuit").first.getAttribute("circuitId"),
              race
                  .findElements("ResultsList")
                  .first
                  .findElements("Result")
                  .first
                  .getAttribute("position"),
              race
                  .findElements("ResultsList")
                  .first
                  .findElements("Result")
                  .first
                  .findElements("Driver")
                  .first
                  .getAttribute("driverId"));
        }).toList();
      });
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
  }

  Widget _getDateOfBirth() {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(50, 0, 0, 0),
        ),
        Icon(MdiIcons.calendar, color: Colors.red[400]),
        Container(
          margin: EdgeInsets.only(right: 20),
        ),
        Text(this.driverStanding.dateOfBirth, style: subHeaderTextStyle),
      ],
    );
  }

  Widget _getNationality() {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(50, 50, 0, 0),
        ),
        Icon(MdiIcons.city, color: Colors.red[400]),
        Container(
          margin: EdgeInsets.only(right: 20),
        ),
        Text(this.driverStanding.nationality, style: subHeaderTextStyle),
      ],
    );
  }

  Widget _getConstructor() {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 50),
        ),
        Icon(MdiIcons.garage, color: Colors.red[400]),
        Container(
          margin: EdgeInsets.only(right: 20),
        ),
        Text(this.driverStanding.constructor, style: subHeaderTextStyle),
      ],
    );
  }

  Widget _getLegend() {
    return Container(
      margin: EdgeInsets.fromLTRB(120, 20, 120, 0),
      child: Row(
        children: <Widget>[
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            "Qualification",
            style: subHeaderTextStyle,
          ),
          SizedBox(
            width: 4,
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            "Race",
            style: subHeaderTextStyle,
          )
        ],
      ),
    );
  }

  Widget _getChart(List qualifyingResults, List raceResults) {
    return Container(
        margin: EdgeInsets.all(10),
        width: 300,
        height: 220,
        child: FlChart(
            chart: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(touchTooltipData:
                TouchTooltipData(getTooltipItems: (touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                return TooltipItem(
                    (20 - touchedSpot.spot.y).toInt().toString(),
                    TextStyle(
                      color: touchedSpot.getColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ));
              }).toList();
            })),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                reservedSize: 2,
                textStyle: regularTextStyle,
                getTitles: (value) {
                  return qualifyingResults
                      .map((result) => result.round)
                      .toList()[value.toInt()];
                },
                margin: 8,
              ),
              leftTitles: SideTitles(
                showTitles: true,
                textStyle: regularTextStyle,
                getTitles: (value) {
                  return List<String>.generate(20, (i) => (i + 1).toString())
                      .reversed
                      .toList()[value.toInt()];
                },
                reservedSize: 2,
                margin: 12,
              ),
            ),
            minX: 0,
            minY: 0,
            lineBarsData: [
              LineChartBarData(
                spots: qualifyingResults
                    .map((result) => FlSpot(double.parse(result.round) - 1,
                        20 - double.parse(result.qualifyingPosition)))
                    .toList(),
                isCurved: true,
                barWidth: 3,
                isStrokeCapRound: true,
                colors: [Colors.orange],
                dotData: FlDotData(
                  show: false,
                ),
                belowBarData: BelowBarData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: raceResults
                    .map((result) => FlSpot(double.parse(result.round) - 1,
                        20 - double.parse(result.position)))
                    .toList(),
                isCurved: true,
                barWidth: 3,
                isStrokeCapRound: true,
                colors: [Colors.blue],
                dotData: FlDotData(
                  show: false,
                ),
                belowBarData: BelowBarData(
                  show: false,
                ),
              )
            ],
          ),
        )));
  }

  BarChartGroupData _makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        color: Colors.blueAccent[100],
        width: 2,
        isRound: true,
      ),
      BarChartRodData(
        y: y2,
        color: Colors.redAccent[400],
        width: 2,
        isRound: true,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: SingleChildScrollView(
            child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: 40),
              ClipRRect(
                  borderRadius: new BorderRadius.circular(90.0),
                  child: Image(
                    image: new AssetImage(
                        "assets/img/drivers/${this.driverStanding.driverId}.jpg"),
                    height: 180,
                    width: 180,
                  )),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  this.driverStanding.name,
                  style: headerTextStyle,
                ),
              ),
              SizedBox(height: 20),
              _getDateOfBirth(),
              _getNationality(),
              _getConstructor(),
              Row(
                children: <Widget>[],
              ),
              _getLegend(),
              raceResults.length > 0
                  ? Column(
                      children: <Widget>[
                        _getChart(this.qualifyingResults, this.raceResults)

                      ],
                    )
                  : Container()
            ],
          ),
        )));
  }
}
