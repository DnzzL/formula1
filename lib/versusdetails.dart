import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:formula1/model/driverstanding.dart';
import 'package:formula1/model/qualifyingresults.dart';
import 'package:formula1/model/raceresults.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class VersusDetailsWidget extends StatefulWidget {
  @override
  _VersusDetailsWidgetState createState() => _VersusDetailsWidgetState();
}

class _VersusDetailsWidgetState extends State<VersusDetailsWidget> {
  Map<String, List<QualifyingResult>> qualifyingResults = Map();
  Map<String, List<RaceResult>> raceResults = Map();
  List<DriverStanding> driverStandings;
  String _value1;
  DriverStanding _driverStanding1;
  String _value2;
  DriverStanding _driverStanding2;

  @override
  initState() {
    super.initState();
    _getDriverStandings();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  static final baseTextStyle = const TextStyle(fontFamily: 'Poppins');
  static final dropdownStyle = baseTextStyle.copyWith(
      color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.w400);
  static final regularTextStyle = baseTextStyle.copyWith(
      color: Colors.white70, fontSize: 14.0, fontWeight: FontWeight.w400);
  final subHeaderTextStyle = regularTextStyle.copyWith(fontSize: 16.0);
  final headerTextStyle = baseTextStyle.copyWith(
      color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w600);

  void _getDriverStandings() async {
    String api = "https://ergast.com/api/f1";
    String url = "$api/current/driverStandings";

    var response = await DefaultCacheManager().getSingleFile(url);
    var xmlResponse = xml.parse(response.readAsStringSync());
    setState(() {
      driverStandings =
          xmlResponse.findAllElements("DriverStanding").map((standing) {
        return DriverStanding(
            standing.getAttribute("position"),
            standing.getAttribute("points"),
            standing.getAttribute("wins"),
            '${standing.findElements("Driver").first.findElements("GivenName").first.text} ${standing.findElements("Driver").first.findElements("FamilyName").first.text}',
            standing
                .findElements("Driver")
                .first
                .findElements("DateOfBirth")
                .first
                .text,
            standing
                .findElements("Driver")
                .first
                .findElements("Nationality")
                .first
                .text,
            standing
                .findElements("Constructor")
                .first
                .findElements("Name")
                .first
                .text,
            standing.findElements("Driver").first.getAttribute("driverId"));
      }).toList();
    });
  }

  void _getDriverStandingsComparison(String driverId1, String driverId2) async {
    setState(() {
      _driverStanding1 = this
          .driverStandings
          .firstWhere((e) => e.driverId == driverId1, orElse: () => null);
      _driverStanding2 = this
          .driverStandings
          .firstWhere((e) => e.driverId == driverId2, orElse: () => null);
    });
    if (_driverStanding1 != null) {
      _fetchQualifyingResults(_driverStanding1);
      _fetchRaceResults(_driverStanding1);
    }

    if (_driverStanding2 != null) {
      _fetchQualifyingResults(_driverStanding2);
      _fetchRaceResults(_driverStanding2);
    }
  }

  Widget _getOutqualified() {
    int rounds = qualifyingResults[_driverStanding1.driverId]
        .map((r) => r.round)
        .toList()
        .length;
    int driver1Outqualified = 0;
    for (var i = 0; i < rounds - 1; i++) {
      if (int.parse(qualifyingResults[_driverStanding1.driverId][i]
              .qualifyingPosition) >
          int.parse(qualifyingResults[_driverStanding2.driverId][i]
              .qualifyingPosition)) {
        driver1Outqualified++;
      }
    }
    if (driver1Outqualified > rounds / 2) {
      return Container(
        margin: EdgeInsets.all(15),
        child: Text(
          "${_driverStanding1.name} outqualified ${_driverStanding2.name} $driver1Outqualified times.",
          style: dropdownStyle,
        ),
      );
    }
    return Container(
        margin: EdgeInsets.all(15),
        child: Text(
          "${_driverStanding2.name} outqualified ${_driverStanding1.name} $driver1Outqualified times.",
          style: regularTextStyle,
        ));
  }

  void _fetchQualifyingResults(DriverStanding driverStanding) async {
    String api = "https://ergast.com/api/f1";
    String url = "$api/current/drivers/${driverStanding.driverId}/qualifying";

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var xmlResponse = xml.parse(response.body);
      print(xmlResponse.findElements("QualifyingResult"));
      setState(() {
        qualifyingResults[driverStanding.driverId] =
            xmlResponse.findAllElements("Race").map((race) {
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

  void _fetchRaceResults(DriverStanding driverStanding) async {
    String api = "https://ergast.com/api/f1";
    String url = "$api/current/drivers/${driverStanding.driverId}/results";

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var xmlResponse = xml.parse(response.body);
      print(xmlResponse.findElements("QualifyingResult"));
      setState(() {
        raceResults[driverStanding.driverId] =
            xmlResponse.findAllElements("Race").map((race) {
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

  Widget _getDateOfBirth(DriverStanding driverStanding) {
    return Row(
      children: <Widget>[
        Icon(MdiIcons.calendar, color: Colors.red[400], size: 20),
        Container(
          margin: EdgeInsets.only(right: 10),
        ),
        Text(driverStanding.dateOfBirth, style: regularTextStyle),
      ],
    );
  }

  Widget _getNationality(DriverStanding driverStanding) {
    return Row(
      children: <Widget>[
        Icon(MdiIcons.city, color: Colors.red[400], size: 20),
        Container(
          margin: EdgeInsets.only(right: 10),
        ),
        Text(driverStanding.nationality, style: regularTextStyle),
      ],
    );
  }

  Widget _getConstructor(DriverStanding driverStanding) {
    return Row(
      children: <Widget>[
        Icon(MdiIcons.garage, color: Colors.red[400], size: 20),
        Container(
          margin: EdgeInsets.only(right: 10),
        ),
        Text(driverStanding.constructor, style: regularTextStyle),
      ],
    );
  }

  Widget _getChart(List qualifyingResults1, List qualifyingResults2) {
    return Container(
        margin: EdgeInsets.all(10),
        width: 350,
        height: 200,
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
                textStyle: dropdownStyle,
                getTitles: (value) {
                  return qualifyingResults1
                      .map((result) => result.round)
                      .toList()[value.toInt()];
                },
                margin: 8,
              ),
              leftTitles: SideTitles(
                showTitles: true,
                textStyle: dropdownStyle,
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
                spots: qualifyingResults1
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
                spots: qualifyingResults2
                    .map((result) => FlSpot(double.parse(result.round) - 1,
                        20 - double.parse(result.qualifyingPosition)))
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

  Widget _driverDetails(DriverStanding driverStanding) {
    return Expanded(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          ClipRRect(
              borderRadius: new BorderRadius.circular(90.0),
              child: Image(
                image: new AssetImage(
                    "assets/img/drivers/${driverStanding.driverId}.jpg"),
                height: 120,
                width: 120,
              )),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              driverStanding.name,
              style: subHeaderTextStyle,
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              children: <Widget>[
                _getDateOfBirth(driverStanding),
                _getNationality(driverStanding),
                _getConstructor(driverStanding),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getDriverDetails() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              driverStandings != null
                  ? Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.grey[850],
                      ),
                      child: DropdownButton<String>(
                        items: driverStandings.map((ds) {
                          return DropdownMenuItem<String>(
                            value: ds.driverId,
                            child: Text(ds.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _value1 = value;
                          });
                        },
                        value: _value1,
                        hint: Text("Driver 1", style: dropdownStyle),
                        style: subHeaderTextStyle,
                      ))
                  : Container(),
              _driverStanding1 != null
                  ? Row(
                      children: <Widget>[
                        _driverDetails(this._driverStanding1),
                      ],
                    )
                  : Container()
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              driverStandings != null
                  ? Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.grey[850],
                      ),
                      child: DropdownButton<String>(
                        items: driverStandings.map((ds) {
                          return DropdownMenuItem<String>(
                            value: ds.driverId,
                            child: Text(ds.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _value2 = value;
                            _getDriverStandingsComparison(_value1, _value2);
                          });
                        },
                        value: _value2,
                        hint: Text("Driver 2", style: dropdownStyle),
                        style: subHeaderTextStyle,
                      ),
                    )
                  : Container(),
              _driverStanding1 != null && _driverStanding2 != null
                  ? Row(
                      children: <Widget>[
                        _driverDetails(this._driverStanding2),
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      ],
    );
  }

  Widget getQualificationDetails() {
    return surroundWithCard(Column(
      children: <Widget>[
        Text(
          "Qualifications",
          style: headerTextStyle,
        ),
        _getChart(qualifyingResults[_driverStanding1.driverId],
            qualifyingResults[_driverStanding2.driverId]),
        _getOutqualified(),
      ],
    ));
  }

  Widget surroundWithCard(Widget cardContent) {
    return Container(
      child: cardContent,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          surroundWithCard(getDriverDetails()),
          _driverStanding1 != null &&
                  _driverStanding2 != null &&
                  qualifyingResults.length > 0
              ? getQualificationDetails()
              : Container()
        ])));
  }
}
