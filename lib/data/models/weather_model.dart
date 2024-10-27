import 'package:forekast_app/utils/common_function.dart';

class Weather {
  String? cityName;
  int? temp;
  int? tempMax;
  int? tempMin;
  int? wind;
  int? humidity;
  int? feelsLike;
  int? pressure;
  String? description;
  String? icon;
  String? country;
  double? lat;
  double? lon;
  String? degree;
  String? timestamp;

  Weather({
    this.cityName,
    this.temp,
    this.tempMax,
    this.tempMin,
    this.wind,
    this.humidity,
    this.pressure,
    this.feelsLike,
    this.description,
    this.icon,
    this.country,
    this.lat,
    this.lon,
    this.degree,
    this.timestamp,
  });

  /// Function to parse JSON data into model

  Weather.fromJSON(Map<String, dynamic> json) {
    cityName = json["name"];
    temp = roundTempValue(json["main"]["temp"]);
    tempMax = roundTempValue(json["main"]["temp_max"]);
    tempMin = roundTempValue(json["main"]["temp_min"]);
    wind = (json["wind"]["speed"]).round();
    humidity = json["main"]["humidity"];
    pressure = json["main"]["pressure"];
    feelsLike = roundTempValue(json["main"]["feels_like"]);
    description = json["weather"][0]["description"];
    icon = json["weather"][0]["icon"];
    country = json["sys"]["country"];
    lat = json["coord"]["lat"];
    lon = json["coord"]["lon"];
    degree = getDirection(json["wind"]["deg"]);
    timestamp = getTime(json["dt"] + json["timezone"]);
  }

  // Function to return json when unknown city is searched

  Weather.voidData() {
    cityName = '';
  }
}

class DailyWeather {
  List<Map<String, dynamic>> model = [];

  DailyWeather.fromJSON(List<dynamic> json) {
    for (var i = 0; i < json.length; i++) {
      model.add({
        "tempMin": roundTempValue(json[i]["temp"]["min"]).toString(),
        "tempMax": roundTempValue(json[i]["temp"]["max"]).toString(),
        "dt": getDateFromEpoch(json[i]["dt"]),
        // "description": rangeDescription(json[i]["weather"][0]["description"]),
        "description": json[i]["weather"][0]["description"],
        "icon": json[i]["weather"][0]["icon"],
      });
    }
  }

  DailyWeather.voidData() {
    model.add({"err": 1});
  }
}
