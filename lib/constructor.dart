import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

class Constructor {
  String name;
  String nationality;
  String url;

  Constructor(String name, String nationality, String url) {
    this.name = name;
    this.nationality = nationality;
    this.url = url;
  }
}

class ConstructorWidget extends StatefulWidget{
  @override
  _ConstructorWidgetState createState() => _ConstructorWidgetState();
}

class _ConstructorWidgetState extends State<ConstructorWidget> {
  final _formKey = GlobalKey<FormState>();

  String season;

  String round;

  final icons = [Icons.directions_bike, Icons.directions_boat,
      Icons.directions_bus, Icons.directions_car, Icons.directions_railway,
      Icons.directions_run, Icons.directions_subway, Icons.directions_transit,
      Icons.directions_walk];

  List<Constructor> constructors = List<Constructor>();

  void fetch() async {
    String api = "https://ergast.com/api/f1";
    String url;

    if (season == null) {
      season = "current";
    }
    if (round == null) {
      url = '$api/$season/constructors';
    } else {
      url = '$api/$season/$round/constructors';
    }
    
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var xmlResponse = xml.parse(response.body);
      setState(() {
        constructors = xmlResponse.findAllElements('Constructor')
        .map<Constructor>((constructor) {
            return Constructor(constructor.findElements("Name").first.text,
            constructor.findElements("Nationality").first.text,
            constructor.getAttribute("url"));
        }).toList();
      });
  
    } else {
      print("Request failed with status: ${response.statusCode}.");
      constructors = List<Constructor>();
    }
    constructors.map<String>((el) => el.name).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Season'),
                  onFieldSubmitted: (val) {
                    setState(() => season = val);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Round'),
                  onSaved: (val) => setState(() => round = val),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        fetch();
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
          constructors.length > 0 ?
          Expanded(
            child:ListView.builder(
          itemCount: constructors.length,
          itemBuilder: (context, index) {
            return Card( //                           <-- Card widget
              child: ListTile(
                leading: Icon(Icons.directions_car),
                title: Text(constructors.map((e)=> e.name).toList()[index]),
                subtitle: Text(constructors.map((e)=> e.nationality).toList()[index]),
              ),
            );
          },
        )
          )
        : Container()
        ],
      )
      );
  }
}