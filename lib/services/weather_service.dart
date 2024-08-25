import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:forekast_app/config/dotenv.dart';
import 'package:forekast_app/data/models/weather_model.dart';

class WeatherApi {
  Future<Weather> getCurrentWeather(String? city) async {
    try {
      // Get the API key from .env file
      final env = await parseStringToMap(assetsFileName: '.env');
      var url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${env["OPENWEATHER_API_KEY_DAILY"]}&units=metric');
      var response = await http.get(url);
      var body = jsonDecode(response.body);
      Weather weather = Weather.fromJSON(body);
      return weather;
    } catch (e) {
      return Weather.voidData();
    }
  }

  Future<DailyWeather> getDailyWeather(double? lat, double? lon) async {
    try {
      final env = await parseStringToMap(assetsFileName: '.env');
      var url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&units=metric&appid=${env["OPENWEATHER_API_KEY_DAILY"]}');
      var response = await http.get(url);
      var body = jsonDecode(response.body);
      DailyWeather data = DailyWeather.fromJSON(body["daily"]);
      return data;
    } catch (e) {
      return DailyWeather.voidData();
    }
  }
}
