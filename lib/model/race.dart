class Race {
  String season;
  String round;
  String circuitId;
  String name;
  String date;
  String time;
  String lat;
  String long;
  String locality;
  String country;

  Race(String season, String round, String circuitId, String name, String date, String time, String lat, String long, String locality, String country) {
    this.season = season;
    this.round = round;
    this.circuitId = circuitId;
    this.name = name;
    this.date = date;
    this.time = time;
    this.lat = lat;
    this.long = long;
    this.locality = locality;
    this.country = country;
  }
}