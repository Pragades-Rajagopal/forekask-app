import 'package:forekast_app/utils/common_function.dart';

class SingleFavoriteWeather {
  String? cityName;
  String? country;
  int? temp;
  int? tempMax;
  int? tempMin;
  String? description;
  String? icon;

  SingleFavoriteWeather({
    this.cityName,
    this.country,
    this.temp,
    this.description,
    this.icon,
    this.tempMax,
    this.tempMin,
  });

  /// Function to parse JSON data into model for single favorite city
  SingleFavoriteWeather.fromJSON(Map<String, dynamic> json) {
    cityName = json["name"];
    country = json["sys"]["country"];
    temp = roundTempValue(json["main"]["temp"]);
    tempMax = roundTempValue(json["main"]["temp_max"]);
    tempMin = roundTempValue(json["main"]["temp_min"]);
    description = json["weather"][0]["description"];
    icon = json["weather"][0]["icon"];
  }
}
